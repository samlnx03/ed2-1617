//-------------------------- FLUJO DE DATOS
module mux_flujo_datos(input i0, i1, s, output x);
	assign x=~s&i0 | s&i1; // se usan las ecuaciones
endmodule


//-------------------------- ESTRUCTURAL
module mux_estructural(input i0, i1, s, output z);

	wire nots, w1, w2;  // se define la esrtuctura del circuito

	and U1(w1, nots, i0);
	and U2(w2, s, i1);
	or U3(z,w1,w2);
	not U4(nots, s);

endmodule

//-------------------------- COMPORTAMIENTO
module mux_comportamiento(input i0, i1, s, output z);
	reg z;
	always @(i0,i1,s) begin // lista sensible i0,i1,s
		if(!s)		// el bloque always se ejecuta si cambia al menos una variable de la lista sensible
			z=i0;
		else
			z=i1;
	end
endmodule



// ----------------------------- BANCO DE PRUEBAS
module mux_tb();
	wire z;
	reg i0,i1,s;

	mux_comportamiento M(i0,i1,s,z); // se instancia el modulo a simular

	initial begin
		$display("time\ti1\ti0\ts\tz");
		$monitor("%4d\t%b\t%b\t%b\t%b",$time,i1,i0,s,z);
		    i1=0; i0=0; s=0;
		#10 i1=0; i0=0; s=1;
		#10 i1=0; i0=1; s=0;
		#10 i1=0; i0=1; s=1;
		#10 i1=1; i0=0; s=0;
		#10 i1=1; i0=0; s=1;
		#10 i1=1; i0=1; s=0;
		#10 i1=1; i0=1; s=1;
	end
endmodule
