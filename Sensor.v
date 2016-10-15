//BCDtoSSeg.v
`timescale 1ns/1ps
module Sensor(input clk, input sensor);
reg [7:0] contadorR = 8'b00000000;
reg [7:0] periodo =   8'b00000000;
reg [7:0] contadorR2 =8'b00000000;
wire [7:0] frecuencia = (periodo/(500000*contadorR2));

always @ (posedge clk)
	begin
		if(contadorR>8'b00000000)
		contadorR<=contadorR +1;
	end


always @ (posedge sensor)
	begin
		if (contadorR==8'b00000000 && contadorR2==8'b00000001)
		contadorR= 8'b00000001;
	end

always @ (negedge sensor)
	begin
		periodo <= contadorR + periodo;
		contadorR<=8'b00000000;
		contadorR2 <= contadorR2 + 1;
	end

endmodule
