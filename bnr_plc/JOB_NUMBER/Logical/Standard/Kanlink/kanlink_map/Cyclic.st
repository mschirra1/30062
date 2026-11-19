
PROGRAM _CYCLIC	
//	//Opener code
//	
//	
//	//Tunnel X
//	r56.open_signal	:= 	Comm[1].DropLoad;
//	r56.receive_signal	:= 	Comm[1].LoadDropped;
//	Comm[1].BagReady	:= r56.sling_ready;
//  
//	IF r56.sling_ready THEN
//		Comm[1].Customer	:= wash_com_cust_1;
//		Comm[1].Category	:= wash_com_cat_1;
//		Comm[1].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_1),ADR(wash_com_batch2_1));
//		Comm[1].Weight		:= (wash_com_wt_1 * 10);
//	ELSE
//		Comm[1].Customer	:= 0;
//		Comm[1].Category	:= 0;
//		Comm[1].BatchID		:= 0;
//		Comm[1].Weight		:= 0;
//	END_IF;
//  
//	IF EDGEPOS(r56.fire) THEN
//		wash_com_cust_1 := 0;
//		wash_com_cat_1  := 0;
//		wash_com_wt_1  := 0;
//		wash_com_batch1_1 := 0;
//		wash_com_batch2_1 := 0;
//	END_IF;
//	
//	
//	
//	
//	//Washer X
///////////Washer 1/////////////
//	Comm[2].Customer	:= wash_com_cust_2;
//	Comm[2].Category	:= wash_com_cat_2;
//	Comm[2].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_2),ADR(wash_com_batch2_2));
//	IF EDGEPOS(Comm[2].ReadyToLoad) THEN
//		r168.transfer_requested_signal := TRUE;
//	END_IF;
//
//	w1_bag_2_wieight 		:= REAL_TO_INT(WORD_TO_REAL(plc_info1)/2.2);  // 2nd Bag wieght - 1 if the wieght is -0 so we know there is 2 bags.
//	w1_doubleDrop			:= (w1_bag_2_wieight > 0);
	//Build the batch of 2
//
//	IF EDGEPOS(r168.loading_signal) THEN // Decider has ran
//		IF w1_doubleDrop THEN
//			Comm[2].Batch_QtyRemaining := 2;
//		ELSE
//			Comm[2].Batch_QtyRemaining := 1;
//		END_IF;
//	END_IF;

//	IF EDGEPOS(r168.state = 40 ) THEN // Bag arrives in the discharger
//		CASE Comm[2].Batch_QtyRemaining OF
//			1:
//				Comm[2].Batchpart[0].Customer := Comm[2].Customer;
//				Comm[2].Batchpart[0].Wgt := (wash_com_wt_2 * 10);
//				Comm[2].Batchpart[1].Customer := 0;
//				Comm[2].Batchpart[1].Wgt := 0;
//				Comm[2].Weight := (wash_com_wt_2 *10);
//			2:
//				Comm[2].Batchpart[0].Customer := Comm[2].Customer;
//				Comm[2].Batchpart[0].Wgt := (wash_com_wt_2 * 10);
//				Comm[2].Batchpart[1].Customer := Comm[2].Customer;
//				Comm[2].Batchpart[1].Wgt := (w1_bag_2_wieight * 10);
//				Comm[2].Weight := ((wash_com_wt_2 + w1_bag_2_wieight) *10);
//		END_CASE;
//	END_IF;
//	
//	IF EDGEPOS(r168.fire) OR NOT(Comm[2].ReadyToLoad) THEN
//		r168.transfer_requested_signal := FALSE;
//	END_IF;
//
//	Comm[2].BagReady	:= r168.sling_ready;
//	r168.open_signal	:= 	Comm[2].DropLoad;
//	r168.receive_signal	:= 	Comm[2].LoadDropped;
//	IF EDGEPOS(Comm[2].LoadDropped) THEN
//		wash_com_cust_2 := 0;
//		wash_com_cat_2  := 0;
//		wash_com_wt_2  := 0;
//		wash_com_batch1_2 := 0;
//		wash_com_batch2_2 := 0;
//		// Count down the loads
//		IF 	Comm[2].Batch_QtyRemaining >= 1 THEN
//			Comm[2].Batch_QtyRemaining := Comm[2].Batch_QtyRemaining - 1;
//		ELSE
//			Comm[2].Batch_QtyRemaining := 0;
//		END_IF;
//	END_IF;
//	
//	
//	
//	//Dryer X
//	DryerOpenTimer1(IN:= r106.sling_ready AND Comm[6].DropLoad, PT := t#1500ms);
//	r106.transfer_requested_signal := Comm[6].ReadyToLoad;
//	r106.open_signal	:= 	DryerOpenTimer1.Q;
//	r106.receive_signal	:= 	Comm[6].LoadDropped;
//	Comm[6].BagReady	:= r106.sling_ready;
//  
//	IF r106.sling_ready THEN
//		Comm[6].Customer	:= wash_com_cust_10;
//		Comm[6].Category	:= wash_com_cat_10;
//		Comm[6].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_10),ADR(wash_com_batch2_10));
//		Comm[6].Weight		:= (wash_com_wt_10 * 10);
//	ELSE
//		Comm[6].Customer	:= 0;
//		Comm[6].Category	:= 0;
//		Comm[6].BatchID		:= 0;
//		Comm[6].Weight		:= 0;
//	END_IF;
//  
//	IF EDGEPOS(r106.fire) THEN
//		wash_com_cust_10 := 0;
//		wash_com_cat_10  := 0;
//		wash_com_wt_10  := 0;
//		wash_com_batch1_10 := 0;
//		wash_com_batch2_10 := 0;
//	END_IF;
//	
//	
//	
//	
//	
//	
//	// Transfers
//	
//	//Wet Transfer X
//	wash_com_cust_6 	:= UDINT_TO_INT(Comm[28].Customer);
//	wash_com_cat_6 		:= UDINT_TO_INT(Comm[28].Category);
//	wash_com_wt_6 		:= (Comm[28].Weight/10);
//	wash_com_batch1_6	:= Get_Lower2Bytes(Comm[28].BatchID);
//	wash_com_batch2_6	:= Get_Higher2Bytes(Comm[28].BatchID);
//	//	Comm[28].bCustom[0]
//			
//	
//	Comm[28].ReadyToLoad	:= r80.sling_ready;
//	r80.transfer_requested_signal := Comm[28].BagReady;
//	r80.xfer_in_progress	:= Comm[28].Unloading;
//	r80.xfer_complete := Comm[28].UnloadFinished;
//
//	IF EDGEPOS(r80.fire) THEN
//		wash_com_cust_6 := 0;
//		wash_com_cat_6 := 0;
//		wash_com_wt_6 := 0;
//		wash_com_batch1_6 := 0;
//		wash_com_batch2_6 := 0;
//	END_IF;	
END_PROGRAM
