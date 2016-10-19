module Sensor(input clk, input sensor);
reg [7:0] periodos,enable,contadorR;
wire [7:0] frecuencia = (contadorR/periodos);

initial
	begin
	periodos = 8'b00000000;
	enable = 8'b00000000;
	contadorR = 8'b00000000;
	end

always @ (posedge clk)
	begin
		if(enable==8'b00000001)
		contadorR=contadorR +1;
	end

always @ (posedge sensor)
	begin
	enable = 8'b00000001;
	periodos = periodos +1;
	end

endmodule
