// Code your testbench here
// or browse Examples
module weekend_tb;
  reg clk;
  reg reset;
  reg valid_in;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire valid_out;
  
  weekend DUT(.*);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  task rst();
    valid_in <= 0;
    data_in <= 8'h0;
    reset <= 0;
    @(posedge clk);
    reset <= 1;
  endtask
  
  task data_gen();
    repeat(10)
      begin
        data_in <= $urandom_range(1,15);
        @(posedge clk);
      end
  endtask
  
  task valid_gen();
    repeat(10)
      begin
        valid_in <= $urandom;
        @(posedge clk);
      end
  endtask
  
  task testcase1;
     @(posedge clk);
      fork
        data_gen();
        valid_gen();
      join
      repeat(5) @(posedge clk);
  endtask
  
  task testcase2;
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd10;
    
    @(posedge clk);
    valid_in <= 0;
    data_in <= 8'd5;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd4;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd7;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd9;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd11;
    
    @(posedge clk);
    valid_in <= 0;
    data_in <= 8'd11;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd12;
    
    repeat(3) @(posedge clk);
  endtask
  
  task testcase3;
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd13;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd3;
    
    @(posedge clk);
    valid_in <= 0;
    data_in <= 8'd12;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd3;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd5;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd2;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd14;
    
    repeat(3) @(posedge clk);
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd1;
    
    @(posedge clk);
    valid_in <= 1;
    data_in <= 8'd8;
    
    @(posedge clk);
    valid_in <= 0;
    data_in <= 8'd2;
    
    repeat(3) @(posedge clk);
  endtask
  
  initial
    begin
      rst();
      testcase1;
      testcase2;
      testcase3;
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, weekend_tb);
    end
  
        
endmodule
