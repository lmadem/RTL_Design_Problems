// Code your design here

module weekend(input clk,
               input reset,
               input valid_in,
               input [7:0] data_in,
               output [7:0] data_out,
               output valid_out);
  
  //internal signals
  reg [7:0] temp1,temp2;
  reg [7:0] out1;

  //Temp1 : Will have first highest
  //Temp2 : Will have second highest
  always @(posedge clk or negedge reset)
    begin
      if(!reset)
        begin
          temp1 <= 8'h0;
          temp2 <= 8'h0;
        end
      else if(valid_in & data_in > temp1)
        begin
          temp1 <= data_in;
          temp2 <= temp1;
        end
      else
        begin 
          temp1 <= temp1;
          temp2 <= temp2;
        end
    end

  
  //Output logic
  always @(posedge clk or negedge reset)
    begin
      if(!reset)
        out1 <= 8'h0;
      else if(valid_in & (data_in < temp1 & data_in >= out1))
        out1 <= data_in;
      else if(valid_in & data_in <= out1)
        out1 <= out1;
      else if(valid_in & (temp1 > temp2 & data_in != temp1))
        out1 <= temp1;
      else if(valid_in & (temp1 > temp2 & data_in == temp1))
        out1 <= temp2;
      else
        out1 <= out1;
    end
  
  assign data_out = out1;
  assign valid_out = data_out > 0;
  
endmodule



