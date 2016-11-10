module disp2(input d_u, output [6:0]s, output [3:0] anodos);
	reg [3:0]decenas=7, unidades=5;
	wire [3:0] d;
	
	assign d=d_u==0 ? unidades : decenas;  // mux
	
	assign anodos[0]=d_u;		// decoder
	assign anodos[1]=~d_u;
	assign anodos[3:2]=2'b11;

	decBin7seg BIN7SEG(d, s);
endmodule

module decBin7seg(input [3:0]a, output reg[6:0]s);
  always @(*) begin
  case (a)
	       // abcdefg   segmentos catodos
    4'b0000: s=7'b0000001;
    4'b0001: s=7'b1001111;
    4'b0010: s=7'b0010010;
    4'b0011: s=7'b0000110;
    4'b0100: s=7'b1001100;
    4'b0101: s=7'b0100100;
    4'b0110: s=7'b0100000;
    4'b0111: s=7'b1110000;
    4'b1000: s=7'b0000000;
    4'b1001: s=7'b0001100;
	4'd10:	 s=7'b0001000;		//a
	4'd11:	 s=7'b1100000;		//b
	4'd12:	 s=7'b0110001;		//c
	4'd13:	 s=7'b1000010;		//d
	4'd14:	 s=7'b0110000;		//e
	4'd15:	 s=7'b0111000;		//f
  endcase
  end
endmodule
