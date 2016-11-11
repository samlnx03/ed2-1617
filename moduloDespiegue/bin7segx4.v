module disp7segx4(
		input clk50M,
		input clk, load1, load0, 
		input [7:0] data,
		output a,b,c,d,e,f,g,dp, output [3:0] anodos
		);
	reg [3:0] millares=3, centenas=2,decenas=1, unidades=0;
	always @(posedge clk) begin
		if(load0) begin
			unidades<=data[3:0];
			decenas<=data[7:4];
		end else if(load1) begin
			centenas<=data[3:0];
			millares<=data[7:4];
		end
	end

	wire [3:0] muxout;
	anodosCtrl AN(clk50M, anodos);
	mux M(muxout, millares,centenas,decenas,unidades, anodos);
	decBin7seg BIN7SEG(muxout, {a,b,c,d,e,f,g});

	assign dp=1'b1; // apagado
endmodule




module anodosCtrl(input clk50M, output [3:0] anodos);
	reg[20:0] divisor=0; // para el div de frec del despliegue multiplexado
	reg [3:0] anodoActivo=4'b1110;
	always @(posedge clk50M)
		divisor<=divisor+1;
	always @(posedge divisor[14])
			anodoActivo={anodoActivo[2:0],anodoActivo[3]}; // corrimiento a la izq.
	assign anodos=anodoActivo;
endmodule




module mux(output [3:0] muxout, input[3:0] millares,centenas,decenas,unidades, input [3:0] anodos);
	assign muxout = 
				millares & {4{~anodos[3]}} |
				centenas & {4{~anodos[2]}} |
				decenas & {4{~anodos[1]}} |
				unidades & {4{~anodos[0]}} ;
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
    4'b0111: s=7'b0001111;
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
