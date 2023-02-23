module matx_top(input [15:0]A,input [7:0]x,output [17:0]y);

	dot dot_1(.A(A[15:8]),.x(x),.y(y[17:9]));
	dot dot_2(.A(A[7:0]),.x(x),.y(y[8:0]));
	
endmodule


module dot(input [7:0]A,input [7:0]x,output [8:0]y);
	assign y = A[7:4]*x[7:4]+A[3:0]*x[3:0];
	
endmodule