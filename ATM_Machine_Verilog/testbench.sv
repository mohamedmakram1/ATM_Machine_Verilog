
module testbench1();
  
  reg  card_handler ;
  reg rst;
  reg clk;
  reg[3:0] in;
  reg[10:0] amount;
  wire [8*66:1] display_str;
  
  ATM DTT(.card_handler(card_handler),.rst(rst),.clk(clk),.in(in), .display_str(display_str),.amount(amount));
	
  reg[32:0] balance; 
  
  always
    begin
      #1 clk = ~clk;
    end

  
  initial
    begin
      $dumpfile("ATM_testBench.vcd");
      $dumpvars ;
      clk = 1'b0;
      amount = 0;
      balance = DTT.balance;
      $display("balance=%d",balance);
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST0)
      else $error("Wrong initial state");
      
      $display("now we entered the card (card_handler = 1)");
      card_handler = 1;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST1)
      else $error("ST0 -> ST1 wrong state transition");
      
      $display("now we choose English");
      in = DTT.EN_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST2)
      else $error("ST1 -> ST2 wrong state transition");
      
      $display("now we enter invalid password");
      in = 4'b0011; // invalid password
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST2)
      else $error("ST2 -> ST2 Wrong password not detected");
      
      $display("now we enter valid password");
      in = DTT.PASSWORD_VAL; // valid password
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST4)
      else $error("ST2 -> ST3 valid password not detected");
      
      $display("now we choose Deposit");
      in = DTT.DEP_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST6)
      else $error("ST4 -> ST6 transition error");
      
      
      $display("now amount = 0 , so no state transition");
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST6)
      else $error("ST6 -> ST6 transition error");
      
      $display("now amount > 0 , so there is state transition");
      amount = 100;
      #2 $display("display_str=%s , %d",display_str,DTT.balance);
      assert (DTT.current_state == DTT.ST12)
      else $error("ST6 -> ST12 transition error");
      balance = balance +amount;
      assert (DTT.balance == balance)
      else $error("balance isn't increasing");
      amount = 0;
      
      $display("return to menu");
      in = DTT.EXT_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST4)
      else $error("ST12 -> ST4 transition error");
      
      $display("choose withdraw operation");
      in = DTT.WDRAW_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST7)
      else $error("ST14 -> ST7 transition error");
      
      $display("withdraw 100$");
      amount = 100;
      #2 $display("display_str=%s , %d",display_str,DTT.balance);
      assert (DTT.current_state == DTT.ST14)
      else $error("ST7 -> ST14 transition error");
      balance = balance - amount;
      assert (DTT.balance == balance)
      else $error("balance is not withdrawed");
      
      $display("return to menu");
      in = DTT.EXT_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST4)
        else $error("ST14 -> ST4 transition error");
      
      $display("choose balance");
      in = DTT.BALANCE_VAL;
      #2 $display("display_str=%s , %d",display_str,DTT.balance);
      assert (DTT.current_state == DTT.ST8)
      else $error("ST4 -> ST8 transition error");
      
      $display("return to menu");
      in = DTT.EXT_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST4)
      else $error("ST8 -> ST4 transition error");
      
      
      $display("reset to st0");
      rst = 1'b1;
      #1 rst = 1'b0;
      card_handler = 1'b0;
      #1
      $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST0)
      else $error("async reset error");
      rst = 1'b1;
      amount = 0;
      
      $display("now re-enter the card (card_handler = 1)");
      card_handler = 1;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST1)
      else $error("ST0 -> ST1 wrong state transition");
      
      $display("now we choose Arabic");
      in = DTT.AR_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST3)
      else $error("ST1 -> ST2 wrong state transition");

      $display("now we enter invalid password");
      in = 4'b0011; // invalid password
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST3)
      else $error("ST3 -> ST3 Wrong password not detected");
      
      $display("now we enter valid password");
      in = DTT.PASSWORD_VAL; // valid password
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST5)
      else $error("ST3 -> ST5 valid password not detected");
      
      $display("now we choose Deposit");
      in = DTT.DEP_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST9)
      else $error("ST5 -> ST9 transition error");
      
      $display("now amount = 0 , so no state transition");
      
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST9)
      else $error("ST9 -> ST9 transition error");
      
      $display("now amount > 0 , so there is state transition");
      amount = 100;
      #2 $display("display_str=%s , %d",display_str,DTT.balance);
      assert (DTT.current_state == DTT.ST13)
      else $error("ST9 -> ST13 transition error");
      balance = balance +amount;
      assert (DTT.balance == balance)
      else $error("balance isn't increasing");
      amount = 0;
      
      $display("return to menu");
      in = DTT.EXT_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST5)
      else $error("ST13 -> ST5 transition error");
      
      $display("choose withdraw operation");
      in = DTT.WDRAW_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST10)
      else $error("ST5 -> ST10 transition error");
      
      $display("withdraw 100$");
      amount = 100;
      #2 $display("display_str=%s , %d",display_str,DTT.balance);
      assert (DTT.current_state == DTT.ST15)
        else $error("ST10 -> ST15 transition error");
      balance = balance - amount;
      assert (DTT.balance == balance)
      else $error("balance is not withdrawed");
      
      $display("return to menu");
      in = DTT.EXT_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST5)
      else $error("ST15 -> ST5 transition error");
      
      $display("choose balance");
      in = DTT.BALANCE_VAL;
      #2 $display("display_str=%s , %d",display_str,DTT.balance);
      assert (DTT.current_state == DTT.ST11)
      else $error("ST5 -> ST12 transition error");
      
      $display("return to menu");
      in = DTT.EXT_VAL;
      #2 $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST5)
      else $error("ST12 -> ST5 transition error");
      
      $display("reset to st0");
      rst = 1'b1;
      #1 rst = 1'b0;
      card_handler = 1'b0;
      #1
      $display("display_str=%s",display_str);
      assert (DTT.current_state == DTT.ST0)
      else $error("async reset error");
      rst = 1'b1;
      
      
    #10
    $finish ;
    end
  
endmodule