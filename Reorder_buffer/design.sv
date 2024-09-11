// Code your design here
module reorder_buffer #(parameter N=8) (input clk,
                                        input rst,
                                        input valid_in,
                                        input ready_in,
                                        input [2:0] id_in,
                                        input [7:0] data_in,
                                        output valid_out,
                                        output ready_out,
                                        output [7:0] data_out
                                       );
  
  //Internal signals
  localparam size = $clog2(N);
  reg [7:0] buffer [N-1 : 0]; //Data buffer
  reg valid [N-1 : 0]; //Validity of each entry
  
  reg [size : 0] wr_ptr; //Pointer for the input data
  reg [size : 0] rd_ptr; //pointer for the output data
  
  reg valid_o; //valid output
  reg ready_o; //ready output
  reg [7:0] data_o;  //data output
  wire buffer_full; //Indicates buffer full
  
  //To store data in a buffer
  always @(posedge clk or posedge rst)
    begin
      if(!rst)
        begin
          for(int i = 0; i < N; i++)
            begin
              valid[i] <= 0;
              buffer[i] <= 0;
            end
          wr_ptr <= 0;
        end
      
      else if(valid_in & ready_in & !valid[id_in])
        begin
          buffer[id_in] <= data_in;
          valid[id_in] <= 1;
          if(wr_ptr == N - 1)
            wr_ptr <= 0;
          else
            wr_ptr <= wr_ptr + 1;
        end
    end
  
  
  //To sample data from buffer
  always @(posedge clk or posedge rst)
    begin
      if(!rst)
        begin
          rd_ptr <= 0;
          valid_o <= 0;
          ready_o <= 0;
          data_o <= 0;
        end
      
      else if(valid[rd_ptr])
        begin
          data_o <= buffer[rd_ptr];
          valid_o <= 1;
          ready_o <= 1;
          valid[rd_ptr] <= 0;
          if(rd_ptr == N - 1)
            rd_ptr <= 0;
          else
            rd_ptr <= rd_ptr + 1;
        end
      
      else if(buffer_full)
        begin
          ready_o <= 0;
        end
      
      else if(rd_ptr == 0)
        begin
          data_o <= buffer[0];
          valid_o <= 0;
        end
      
      else
        begin
          valid_o <= 0;
          ready_o <= 1;
          data_o <= 0;
        end
    end
  
  assign buffer_full = (wr_ptr == N-1 & rd_ptr == 0);
  assign valid_out = valid_o;
  assign ready_out = ready_o;
  assign data_out = data_o;
endmodule

