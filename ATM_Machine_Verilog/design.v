`define WELCOME_STR "Please insert your card" //23 char
`define WELCOME_STR_LEN 23
`define LAN_STR "Please choose your language\n1.Arabic\n2.English"
`define LAN_STR_LEN 46
`define PASS_EN_STR  "Please Enter your password"
`define PASS_EN_STR_LEN 26
`define PASS_AR_STR  "الرجاء ادخال كلمه السر"
`define PASS_AR_STR_LEN 22
`define MENU_EN_STR  "Please choose your operation\nDeposit(9)\nWithdraw(5)\nBalance(3)"
`define MENU_EN_STR_LEN 62
`define MENU_AR_STR  "الرجاء اختيار العمليه , ايداع(9) ,سحب(5),كشف حساب(3)"
`define MENU_AR_STR_LEN 52
`define SUCCESS_EN  "Operation is done successfully , your balance now is"
`define SUCCESS_EN_LEN 52
`define SUCCESS_AR  "العمليه تمت بنجاح , رصيدك الحالى"
`define SUCCESS_AR_LEN 32
`define DEP_EN  "Enter amount you want to deposit"
`define DEP_EN_LEN 32
`define WDRAW_EN  "Enter amount you want to withdraw"
`define WDRAW_EN_LEN 33
`define DEP_AR  "ادخل الرقم الذى تريد ايداعه"
`define DEP_AR_LEN 32
`define WDRAW_AR  "ادخل الرقم الذى تريد سحبه"
`define WDRAW_AR_LEN 33

module ATM (
  	input  wire        card_handler , // changes to 1 when card is placed 
	input  wire        rst, // async reset
	input  wire        clk, // async clk
  input wire [3:0]     in, // in from user enters data
  output reg [8*66:1]        display_str, // output message displayed on user screen
  input wire[10:0] amount // amount used when you want to submit value for deposit or withdraw
);
  parameter[3:0] AR_VAL = 4'b0001,
   				 EN_VAL = 4'b0010,
  				 DEP_VAL = 4'b1001,
  				 WDRAW_VAL = 4'b0101,
  				 BALANCE_VAL = 4'b0011,
  				 PASSWORD_VAL = 4'b1111,
  				 EXT_VAL = 4'b0000;
  
  
  
  localparam[3:0]   ST0 = 4'b0000,
                    ST1 = 4'b0001,
  					ST2 = 4'b0010,
                    ST3 = 4'b0011,
  					ST4 = 4'b0100,
                    ST5 = 4'b0101,
   					ST6 = 4'b0110,
                    ST7 = 4'b0111,
   					ST8 = 4'b1000,
                    ST9 = 4'b1001,
   					ST10 = 4'b1010,
                    ST11 = 4'b1011,
   					ST12 = 4'b1100,
                    ST13 = 4'b1101,
   					ST14 = 4'b1110,
                    ST15 = 4'b1111;
   					
  reg [32:0] balance;					
   					
  reg[3:0]         	current_state,
                    next_state;
  
  initial 
    begin
      balance = 1000000;
      current_state = ST0;
    end
  
  always @(posedge clk or negedge rst)
   begin
    if(!rst)
     begin
       current_state <= ST0 ;
     end
    else
     begin
       current_state <= next_state ;
     end
   end
  
  always @(*)
   begin
    case(current_state)
    ST0     : begin
      		  if(card_handler==1'b1)
                 next_state = ST1;
                else
                 next_state = ST0 ;			  
               end
    ST1     : begin
      			if(in == EN_VAL)
                 next_state = ST2 ;
      			else if (in == AR_VAL)
                 next_state = ST3 ;
                else
                 next_state = ST1 ;	   
              end
    ST2     : begin
      			if(in == PASSWORD_VAL)
                 next_state = ST4 ;
                else
                 next_state = ST2 ;	    
              end
    ST3     : begin
      			if(in == PASSWORD_VAL)
                 next_state = ST5 ;
                else
                 next_state = ST3 ;	    
              end
    
    ST4     : begin
      			if(in == DEP_VAL)
                 next_state = ST6 ;
      			else if(in == WDRAW_VAL)
                 next_state = ST7 ;
      			else if(in == BALANCE_VAL)
                 next_state = ST8 ;      		
                else
                 next_state = ST4 ;	    
              end
      
    ST5     : begin
      		  	if(in == DEP_VAL)
                 next_state = ST9 ;
      			else if(in == WDRAW_VAL)
                 next_state = ST10 ;
      			else if(in == BALANCE_VAL)
                 next_state = ST11 ;      		
                else
                 next_state = ST5 ;	    
              end

    ST6     : begin
               if( in ==  EXT_VAL)
                 next_state = ST4 ;
      		   else if(amount > 0 )
                 begin
                  balance = balance + amount;
                  next_state = ST12 ;
                 end
                else
                 next_state = ST6 ;	    
              end

    ST7     : begin
      			if( in ==  EXT_VAL)
                 next_state = ST4 ;
               else if(amount > 0 && amount <= balance  )
                 begin
                  balance = balance - amount;
                  next_state = ST14 ;
                 end
                else
                 next_state = ST7 ;	    
              end

    ST8     : begin
      			if( in ==  EXT_VAL)
                 next_state = ST4 ;
                else
                 next_state = ST8 ;	    
              end
    
     ST9     : begin  
       		 if( in ==  EXT_VAL)
                 next_state = ST5 ;
      		   else if(amount > 0 )
                 begin
                  balance = balance + amount;
                  next_state = ST13 ;
                 end
                else
                 next_state = ST9 ;	    
              end

    ST10     : begin
      			if( in ==  EXT_VAL)
                 next_state = ST5 ;
               else if(amount > 0 && amount <= balance  )
                 begin
                  balance = balance - amount;
                  next_state = ST15 ;
                 end
                else
                 next_state = ST10 ;	    
              end

    ST11     : begin
      			if( in ==  EXT_VAL)
                 next_state = ST5 ;
                else
                 next_state = ST11 ;	    
              end
    ST12     : begin
      			if( in ==  EXT_VAL)
                 next_state = ST4 ;
                else
                 next_state = ST12 ;	    
              end
    ST14     : begin
      			if( in ==  EXT_VAL)
                 next_state = ST4 ;
                else
                 next_state = ST14 ;	    
              end
    ST13     : begin
      			if( in ==  EXT_VAL)
                 next_state = ST5 ;
                else
                 next_state = ST13 ;	    
              end
    ST15     : begin
      			if( in ==  EXT_VAL)
                 next_state = ST5 ;
                else
                 next_state = ST15 ;	    
              end

    
      
      default :   next_state = ST0 ;		 

    endcase
  end
  
  always @(*)
   begin
    case(current_state)
    ST0     : begin
      display_str[8*66:8*(66-`WELCOME_STR_LEN)+1]   =  `WELCOME_STR;	  display_str[8*(66-`WELCOME_STR_LEN):1] = 0;
               end
    ST1       : begin
      display_str[8*66:8*(66-`LAN_STR_LEN)+1]   =  `LAN_STR;
      display_str[8*(66-`LAN_STR_LEN):1] = 0;
               end	
    ST2      : begin
      display_str[8*66:8*(66-`PASS_EN_STR_LEN)+1]   =  `PASS_EN_STR;	   display_str[8*(66-`PASS_EN_STR_LEN):1] = 0;
               end
    ST3     : begin
      display_str[8*66:8*(66-`PASS_AR_STR_LEN)+1]   =  `PASS_AR_STR;	   display_str[8*(66-`PASS_AR_STR_LEN):1] = 0;
               end
    ST4    : begin
      display_str[8*66:8*(66-`MENU_EN_STR_LEN)+1]   =  `MENU_EN_STR;
      display_str[8*(66-`MENU_EN_STR_LEN):1] = 0;
    		end
   	ST5    : begin
      display_str[8*66:8*(66-`MENU_AR_STR_LEN)+1]   =  `MENU_AR_STR;
      display_str[8*(66-`MENU_AR_STR_LEN):1] = 0;
               end			 
    ST6     : begin
      display_str[8*66:8*(66-`DEP_EN_LEN)+1]   =  `DEP_EN;
      display_str[8*(66-`DEP_EN_LEN):1] = 0;
               end
    ST7    : begin
      display_str[8*66:8*(66-`WDRAW_EN_LEN)+1]   =  `WDRAW_EN;
      display_str[8*(66-`WDRAW_EN_LEN):1] = 0;
    		end
   	ST8    : begin
      display_str[8*66:8*(66-`SUCCESS_EN_LEN)+1]   =  `SUCCESS_EN;
      display_str[8*(66-`SUCCESS_EN_LEN):1] = 0;
    		end
    ST9     : begin
      display_str[8*66:8*(66-`DEP_AR_LEN)+1]   =  `DEP_AR;
      display_str[8*(66-`DEP_AR_LEN):1] = 0;
               end
    ST10    : begin
      display_str[8*66:8*(66-`WDRAW_AR_LEN)+1]   =  `WDRAW_AR;
      display_str[8*(66-`WDRAW_AR_LEN):1] = 0;
    		end
   	ST11    : begin
      display_str[8*66:8*(66-`SUCCESS_AR_LEN)+1]   =  `SUCCESS_AR;
      display_str[8*(66-`SUCCESS_AR_LEN):1] = 0;
    		end
    ST12     : begin
      display_str[8*66:8*(66-`SUCCESS_EN_LEN)+1]   =  `SUCCESS_EN;
      display_str[8*(66-`SUCCESS_EN_LEN):1] = 0;
               end
    ST13    : begin
      display_str[8*66:8*(66-`SUCCESS_AR_LEN)+1]   =  `SUCCESS_AR;
      display_str[8*(66-`SUCCESS_AR_LEN):1] = 0;
    		end
   	ST14    : begin
      display_str[8*66:8*(66-`SUCCESS_EN_LEN)+1]   =  `SUCCESS_EN;
      display_str[8*(66-`SUCCESS_EN_LEN):1] = 0;
    		end
   	ST15    : begin
      display_str[8*66:8*(66-`SUCCESS_AR_LEN)+1]   =  `SUCCESS_AR;
      display_str[8*(66-`SUCCESS_AR_LEN):1] = 0;
    		end     
   default  : begin
                display_str   =  "";
               end			  
    endcase
   end	
		
		
endmodule
