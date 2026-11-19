
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackSlingToBelt

	messages ACCESS p_messages;
	loadcell ACCESS p_loadcell;

	IF udp_data.state = 0 THEN
    IF (state > 0) THEN
      udp_data.state := state;
    ELSE
      udp_data.state := state := Resetting;
    END_IF;
  END_IF;

	// Device State Machine
	IF reset THEN
		udp_data.state := state := Resetting;
		man_send := FALSE;
		purge := FALSE;
        cc_shut_top_os := FALSE;
        cc_open_top_os := FALSE;
	END_IF;

	IF OverWeightTimer.Q AND ((udp_data.state = Loading) OR (udp_data.state = NearWeight) OR (udp_data.state = FullWeight)) THEN
		udp_data.state := state := OverWeight;
	END_IF;

	CASE udp_data.state OF

		Resetting:
			IF ResettingTimer.Q THEN
				allowOverweightRelease := 0;
				udp_data.state := state := TransitToLoading;
			END_IF;

		TransitToLoading:
			IF TransitToLoadingTimer.Q THEN
				udp_data.state := state := Loading;
			END_IF;

		Loading:
			IF NearWeightTimer.Q THEN
				udp_data.state := state := NearWeight;
			ELSIF man_send THEN
				udp_data.state := state := FullWeight;
			ELSIF purge AND NOT(safety_zone) THEN
              udp_data.state := state := Purge;
            ELSIF cc_shut_top_os THEN
                cc_shut_top_os := FALSE;
                udp_data.state := state := Buffering;
            END_IF;

		NearWeight:
			IF FullWeightTimer.Q THEN
				udp_data.state := state := FullWeight;
			ELSIF man_send THEN
				udp_data.state := state := FullWeight;
			ELSIF purge AND NOT(safety_zone) THEN
                  udp_data.state := state := Purge;
            ELSIF cc_shut_top_os THEN
                  cc_shut_top_os := FALSE;
                  udp_data.state := state := Buffering;
			END_IF;

		Buffering:
            cc_shut_top_os := FALSE;
            IF cc_open_top_os THEN
                cc_open_top_os := FALSE;
                udp_data.state := state := Resetting;
            ELSIF man_send THEN
                udp_data.state := state := FullWeight;
            ELSIF purge AND NOT(safety_zone) THEN
               udp_data.state := state := Purge;
            END_IF;

		FullWeight:
			IF CloseTopDoorTimer.Q THEN
				udp_data.state := state := ReadyToRelease;
				man_send := FALSE;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
			ELSIF OverWeightTimer.Q THEN
				udp_data.state := state := OverWeight;
			END_IF;

		Releasing:
             IF (after OR NOT(fire)) AND loadcell.empty THEN
                allowOverweightRelease := 0;
                udp_data.state := Resetting;
            ELSIF NOT loadcell.empty THEN
            	CASE messages.Read[BAG_NOT_EMPTY] OF
                	1: //'retry'
                  		udp_data.state := ReadyToRelease;
                	2: //'bag confirmed empty - reset'
						allowOverweightRelease := 0;
                  		udp_data.state := Resetting;
              	END_CASE;
            END_IF;

		Purge:
			IF PurgeTimer.Q THEN
				udp_data.state := state := Resetting;
				purge := FALSE;
			END_IF;

		OverWeight:
            IF (messages.Read[OVERWEIGHT] = 1) AND WeightOk.Q THEN
                state := Loading;
            ELSIF (messages.Read[OVERWEIGHT] = 2) THEN
                allowOverweightRelease := 1;
               	state := ReadyToRelease;
            END_IF;


	END_CASE;

	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND NOT(custom_send_lock)
	AND NOT(after)
	AND NOT(safety_zone)
	AND NOT (loadcell.over_weight)
	);

	// Inserts
	IF going_to AND arrive THEN insert := TRUE; END_IF;


	IF udp_data.state = NearWeight OR udp_data.state = Loading THEN
		loadcell.capture_weight_bool := TRUE;
	ELSE
		loadcell.capture_weight_bool := FALSE;
	END_IF;

	// Input Control
	IF man_send_button OR man_send_button_1 OR man_send_button_2 THEN
		man_send := TRUE;
	END_IF;

	// Output Control
	open_bottom := releasing := ReleaseDelayTimer.Q;
	close_top := (
	udp_data.state = FullWeight
	OR udp_data.state = ReadyToRelease
	OR udp_data.state = Releasing
	OR udp_data.state = Resetting
	OR udp_data.state = Purge
	OR udp_data.state = Buffering
	);

	green_light := (onoff) AND NOT(udp_data.state = FullWeight);

	red_light := (
	((loadcell.notify_weight AND SlowOnPulseTimer.Q)
	OR udp_data.state = FullWeight
	OR udp_data.state = ReadyToRelease
	OR udp_data.state = Releasing
	OR udp_data.state = Resetting
	AND NOT(loadcell.over_weight))
	OR (loadcell.over_weight AND FastOnPulseTimer.Q)
	);
 

  // Control Timers
	NearWeightTimer(IN := (loadcell.near_weight), PT := NearWeightTime);
	FullWeightTimer(IN := (loadcell.full), PT := FullWeightTime);
	CloseTopDoorTimer(IN := (udp_data.state = FullWeight), PT := CloseTopDoorTime);
	ResettingTimer(IN := (udp_data.state = Resetting), PT := ResettingTime);
	TransitToLoadingTimer(IN := (udp_data.state = TransitToLoading), PT := TransitToLoadingTime);
	ReleaseDelayTimer(IN := udp_data.state = Releasing, PT:= ReleaseDelayTime);
	PurgeTimer(IN := udp_data.state = Purge AND conveyor_rail_running AND NOT(safety_zone) AND open_bottom, PT:= PurgeTime);
	WeightOk(IN := (udp_data.state = OverWeight), PT:= WeightOkTime);
	ton_bag_not_empty(IN := ((state = Releasing) AND NOT loadcell.empty),PT := bag_not_empty_time);  


	FastOnPulseTimer(IN := NOT(FastOffPulseTimer.Q), PT := FastOnPulseTime);
	FastOffPulseTimer(IN := FastOnPulseTimer.Q, PT := FastOffPulseTime);
	SlowOnPulseTimer(IN := NOT(SlowOffPulseTimer.Q), PT := SlowOnPulseTime);
	SlowOffPulseTimer(IN := SlowOnPulseTimer.Q, PT := SlowOffPulseTime);


	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	udp_data.alarm := alarm := AlarmTimer.Q;
	OverWeightTimer(IN := (loadcell.over_weight AND NOT(rail_mt) AND NOT allowOverweightRelease), PT := OverWeightTime);

	messages.Write := 0;
	IF (state = OverWeight)  THEN messages.Write := BIT_SET(messages.Write,OVERWEIGHT); END_IF;
	IF ton_bag_not_empty.Q THEN messages.Write := BIT_SET(messages.Write,BAG_NOT_EMPTY); END_IF;
	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));




END_FUNCTION_BLOCK
