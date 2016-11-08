module Sensor(input clk,input sensor,output reg [7:0] JA,output reg [6:0] led);
reg [1:0] filtro;
reg [31:0] CR,CG,CB,CC,A,Az,R,V,N,B;
reg [0:0] final,final2;

reg [31:0] suma;

/*
S0 = JA1 - B13
S1 = JA7 - G13
S2 = JA3 - D17
S3 = JA9 - D18
*/

function [31:0] abs;
	input [31:0] a,b;
	begin
	if(a<b)
		abs=b-a;
	else
		abs=a-b;
	end
endfunction

function [0:0] menor;
	input [31:0] a,b,c,d,e,f;
	begin
	if((a<b)&(a<c)&(a<d)&(a<e)&(a<f))
		menor=1;
	else
		menor=0;
	end
endfunction

initial
	begin
	suma=0;
	A=0;
	Az=0;
	R=0;
	V=0;
	N=0;
	B=0;
	led=6'd0;
	final=1'b0;
	final2=1'b0;
	filtro = 2'b00;
	CR =0;
	CG =0;
	CB =0;
	CC =0;
	end

always @ (posedge clk)
	if(final==1'b1 && final2==1'b0)
	begin
		CR =0;
		CG =0;
		CB =0;
		CC =0;
		final2=1'b1;
		
	end
	else
	
	if(final==1'b0 && final2==1'b1)
		begin
		final2=1'b0;
		end
	else
		begin
		case(filtro)
		2'b00:
			begin
			JA= 8'b00010001;
			CR = CR +1'b1;			
			end
		2'b01:
			begin
			JA= 8'b01010001;//Filtro Azul
			CB = CB +1'b1;
			end
		2'b10:
			begin
			JA= 8'b00010101; //Sin Filtro.
			CC = CC +1'b1; 
			end
		2'b11:
			begin
			JA= 8'b01010101; //Filtro Verde.
			CG = CG +1'b1;
			end
	endcase
		end
		
	

always @(posedge sensor)
	if(filtro < 2'b11)
		begin
		final=1'b0;
		filtro =filtro + 2'b01;
		end
	else
		begin
		filtro=2'b00;
		final=1'b1;
		end


always @ (posedge final)
	begin
	//amarillo,azul,rojo,verde,naranja,blanco.
	suma= CR+CG+CB+CC;
	A=abs(suma,32'd);
	Az=abs(suma,32'd);
	R=abs(suma,32'd);
	V=abs(suma,32'd);
	N=abs(suma,32'd);
	B=abs(suma,32'd);

	if(menor(A,Az,R,V,N,B)==1)
		led=7'b0000001;
	else if(menor(Az,R,V,N,B,A)==1)
		led=7'b0000010;
	else if(menor(R,V,N,B,A,Az)==1)
		led=7'b0000100;
	else if(menor(V,N,B,A,Az,R)==1)
		led=7'b0001000;
	else if(menor(N,B,A,Az,R,V)==1)
		led=7'b0010000;
	else if(menor(B,A,Az,R,V,N)==1)
		led=7'b0100000;
	else
		led=7'b1000000;
	end
	
endmodule
