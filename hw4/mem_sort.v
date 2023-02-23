module mem_sort
#(parameter DATA_WIDTH = 8, ADDR_WIDTH = 4)
 (input clk,
  input reset,
  input start,
  output reg done,
  output reg en, // Enable the memory device.
  output reg we, // we == 1 for write operation.
  output reg [ADDR_WIDTH-1 : 0] addr,
  output reg [DATA_WIDTH-1 : 0] data_o,
  input  [DATA_WIDTH-1 : 0] data_i
  );
integer count=0;

initial begin
  en<=1;
  we<=0;
  addr<=0;
  done<=0;
end
parameter IDLE = 2'b00;
parameter READ16 = 2'b01;
parameter WRITE16 = 2'b11;
parameter SORT = 2'b10;
reg [1:0] Q;
reg [7:0] arr [15:0];
reg [7:0] swap;


always @(posedge clk)begin
  if(reset)begin
    en<=0;
    Q<=IDLE;
    for(integer i=0;i<16;i++)begin
      arr[i]<=0;
    end
  end


  if(Q==IDLE)begin
    for(integer i=0;i<16;i++)begin
      arr[i]<=0;
    end
    en<=1;
    done<=0;
    we<=0;
    if(start==1) Q<=READ16;
  end


  else if(Q==READ16)begin
    en<=1;
    arr[(count+15)%16]<=data_i;
    count<=count+1;
    addr<=(count+15)%16;
    if(count==17)begin
      Q=SORT;
      count<=0;
    end
    
  end


  else if(Q==SORT)begin
    en<=1;
     for(integer j=0;j<16;j++)begin
			  for(integer k=15;k>j;k--)begin
			    if(arr[k]>arr[k-1])begin
                swap=arr[k-1];
                arr[k-1]=arr[k];
                arr[k]=swap;
			    end
			  end
		  end
    Q=WRITE16;
  end

  else if(Q==WRITE16)begin
    addr<=(count+15)%16;
    en<=1;
    data_o<=arr[(count+15)%16];
    we<=1;
    count<=count+1;
    if(count==16) begin
      Q=IDLE;
      done<=1;
      count<=count%16;
    end

    
  end
end

endmodule