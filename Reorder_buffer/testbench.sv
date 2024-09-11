// Code your testbench here
// or browse Examples
module reorder_buffer_tb;
  reg clk;
  reg reset;
  reg valid_in;
  reg [2:0] id;
  reg ready_in;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire valid_out;
  wire ready_out;
  
  reorder_buffer #(8) DUT(.clk(clk),
                      .rst(reset),
                      .valid_in(valid_in),
                      .id_in(id),
                      .ready_in(ready_in),
                      .data_in(data_in),
                      .data_out(data_out),
                      .valid_out(valid_out),
                      .ready_out(ready_out)
                     );
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  task preset;
    valid_in = 1'b0;
    ready_in = 1'b1;
    id = 3'b000;
    data_in = 8'h0;
    reset = 1'b0;
  endtask
  
  task rst;
    reset = 1'b0;
    repeat(2) @(posedge clk);
    reset = 1'b1;
  endtask
  
  //Id : 0,1,2,3,4,5,6,7 : sequential access
  task testcase1;
    for(bit [3:0] i=0; i<8; i++)
      begin
        valid_in = 1'b1;
        id = i;
        data_in = $urandom_range(0,100);
        @(posedge clk);
      end
    //@(posedge clk);
    valid_in = 1'b0;
    
  endtask
  
  // Id : 7,6,5,4,3,2,1,0 : In reverse order
  task testcase2;
    bit [3:0] i=7;
    repeat(8)
      begin
        valid_in = 1'b1;
        id = i;
        i--;
        data_in = $urandom_range(0,100);
        @(posedge clk);
      end
    //@(posedge clk);
    valid_in = 1'b0;
    
  endtask
  
  //Directed test
  task testcase3;
    valid_in = 1'b1;
    id = 5;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 0;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 1;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 3;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 2;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 6;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 4;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 7;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    valid_in = 1'b0;
    
  endtask
  
  //Directed test
  task testcase4;
    valid_in = 1'b1;
    id = 1;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 0;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 3;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 2;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 5;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 4;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 7;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    id = 6;
    data_in = $urandom_range(100);
    @(posedge clk);
    
    valid_in = 1'b0;
    
  endtask
  
  //without asserting valid_in : Issue found(NOT SURE), ready_out remained asserted even when the buffer is full
  task testcase5;
    for(bit [3:0] i=0; i<8; i++)
      begin
        valid_in = 1'b0;
        id = i;
        data_in = $urandom_range(0,100);
        @(posedge clk);
      end
    //@(posedge clk);
    valid_in = 1'b0;
    
  endtask
  
  
  //single entry ID 
  task testcase6;
    repeat(4)
      begin
        valid_in = 1'b1;
        id = 1;
        data_in = $urandom_range(0,100);
        @(posedge clk);
      end
    
    id = 0;
    data_in = $urandom_range(0,100);
    @(posedge clk);
    
    //@(posedge clk);
    valid_in = 1'b0;
    
  endtask
  
  //reset task
  task testcase7;
    begin
      rst;
      testcase1;
    end
  endtask
  
  initial
    begin
      preset;
      rst;
      testcase1;
      repeat(10) @(posedge clk);
      testcase2;
      repeat(10) @(posedge clk);
      testcase3;
      repeat(10) @(posedge clk);
      testcase4;
      repeat(10) @(posedge clk);
      /*
      testcase5;
      repeat(10) @(posedge clk);
      testcase6;
      repeat(10) @(posedge clk);
      testcase7;
      repeat(10) @(posedge clk);
      */
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, reorder_buffer_tb);
    end
endmodule
