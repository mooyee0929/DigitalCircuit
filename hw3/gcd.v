module gcd
(
    input [15:0]A,
    input [15:0]B,
    input start,
    input reset,
    input clk,
    output reg [15:0]D,
    output reg valid
);

parameter IDLE = 3'b000;
parameter a_gt_b = 3'b001;
parameter equal = 3'b111;
parameter b_gt_a = 3'b100;
parameter comp = 3'b010;

reg [15:0]a,b;
reg [2:0]Q , Q_next;

always @(posedge clk)begin
    if (reset) Q <= IDLE;
    else       Q <= Q_next;
end

//to do in every state
always@(posedge clk)begin
   if(reset)begin         
   a<=16'b0;b<=16'b0;
   end
   else if(start==1'b1 && Q ==IDLE)begin
   a<=A;b<=B;
   end
   else if(Q==a_gt_b) a<=a-b;
   else if(Q==b_gt_a) b<=b-a;
end

always @(posedge clk) begin
   if(reset)begin
   valid <= 1'b0;D <= 16'b0;
   end
   else if(Q==IDLE) valid<=1'b0;
   else if(Q==equal)begin
   valid<=1'b1;D<=a;
   end
   else begin
   valid<=1'b0;
   end
end

always @(*) begin
    case(Q)
        IDLE:       Q_next <= (start==1)?comp:IDLE;
        a_gt_b:     Q_next <= comp;
        equal:      Q_next <= IDLE;
        b_gt_a:     Q_next <= comp;
        comp:       Q_next <= (a>b)?a_gt_b:((a<b)? b_gt_a:equal);
    endcase
end

endmodule

module gcd_top 
(
    input [15:0]A,
    input [15:0]B,
    input [15:0]C,
    input start,
    input reset,
    input clk,
    output [15:0]D,
    output valid
);
wire [15:0] tmp_d;
wire tmp_valid;

gcd gcd_top_1(.A(A),.B(B),.start(start),.reset(reset),.clk(clk),.D(tmp_d),.valid(tmp_valid));

gcd gcd_top_2(.A(tmp_d),.B(C),.start(tmp_valid),.reset(reset),.clk(clk),.D(D),.valid(valid));
endmodule