module inport #(parameter WIDTH=8) 
	(input oe, clk, ok2send, output reg ready, output [WIDTH-1:0]q);
	reg [WIDTH-1:0] valor=5;

	parameter [1:0] INICIAL=3'b00,
			WAIT_OK2SEND=3'b01,
			WAIT_NOT_OE=3'b10;
	reg [1:0] state, next;

	assign q = (oe) ? valor : {WIDTH{1'bz}};
	// el valor sera wire y se cambia con el teclado

	// maq de estado
	always @(posedge clk) begin
		state=next;
	end
	always @(*) begin
		case (state)
			INICIAL: begin
				if(~oe) begin next=INICIAL; ready=1'b0; end
				else if(~ok2send) begin next=WAIT_OK2SEND; ready=1'b1; end
				end
			WAIT_OK2SEND: begin
				if(!oe) begin next=INICIAL; ready=1'b0; end  // reset?
				else if(~ok2send) begin next=WAIT_OK2SEND; ready=1'b1; end
				else begin next=WAIT_NOT_OE; ready=1'b1; end
				end
			WAIT_NOT_OE: begin
				if(oe) begin next=WAIT_NOT_OE; ready=1'b0; end
				else begin next=INICIAL; ready=1'b0; end
				end
			default: next=INICIAL;
		endcase

	end
endmodule

