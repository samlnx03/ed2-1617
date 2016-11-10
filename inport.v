module inport #(parameter WIDTH=8) 
	(input reset, oe, ok2send, output reg stopSeq, output [WIDTH-1:0]q);
	// stopSeq es una señal para detener el secuenciador
	// 		sube al subir oe y baja al subir ok2send
	// ok2send se debe subir para indicar que el dato esta listo para ser leido
	reg [WIDTH-1:0] valor=5;

	assign q = (oe) ? valor : {WIDTH{1'bz}};
	// el valor sera wire y se cambia con el teclado
	
	assign ok=ok2send | reset;
	always @(posedge oe, posedge ok) begin
		if(ok2send)
			stopSeq<=1'b0;
		else
			stopSeq<=1'b1;
	end
endmodule


module inport_tb();
	reg clk;
	reg reset, oe, ok2send;
	wire stopSeq;
	wire [7:0]q;

	inport INP1(reset, oe,ok2send,stopSeq,q);

	initial begin
		$monitor("t=%3d, clk=%b, oe=%b, ok2send=%b, -- stopSeq=%b, q=%d",
			$time, clk, oe, ok2send, stopSeq, q);
		reset=0; oe=0; clk=0; ok2send=0;
	end
	initial forever #10 clk=~clk;
	initial #100 $finish;
	initial begin
		#31 $display("\nok2send antes de 1 ciclo");
		oe=1;
		#5 ok2send=1; #2 ok2send=0;
		#13 oe=1'b0;
	end

	initial begin
		#71 $display("\nok2send despues de 1 ciclo");
		oe=1;
		#20 ok2send=1; #2 ok2send=0;
		#13 oe=1'b0;
	end
endmodule
