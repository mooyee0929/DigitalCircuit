module sort(input [31:0] A,output [31:0] B);
	integer i,j,k,tmp;
	reg [0:3]array[7:0];
	always@(*)begin
		for(i=7;i>=0;i--)begin
			array[i]=A[(i*4)+:4];
		end
		
		for(j=0;j<7;j++)begin
			for(k=7;k>j;k--)begin
			if(array[k]<array[k-1])begin
				tmp=array[k];
				array[k]=array[k-1];
				array[k-1]=tmp;
			end
			end
		end
	end
	genvar o;
	generate
	for(o=7;o>=0;o=o-1)begin
		assign B[((o*4))+:4]=array[o];
	end
	endgenerate
endmodule