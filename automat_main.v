module automat_main(

	input [0:0] SW, 
	input [3:0] KEY, 
	input CLOCK_50, 
	output [7:0] LEDG,             // выходной сигнал
	output [7:0] HEX3, 
	output [7:0] HEX2, 
	output [7:0] HEX1, 
	output [7:0] HEX0, 
	output reg [9:0] LEDR,         // красные диоды, показывающие значение в регистре
	output reg [2:0] currentState, // регистр для хранения текущего состояния
	output reg [9:0] register
	
);

parameter [1:0] reset = 0;
// 12 вариант 1100111
// инициализация состояний
parameter state1 = 1, state11 = 2, state110 = 3, state1100 = 4, state11001 = 5, state110011 = 6, state1100111 = 7;

initial currentState = reset;

assign HEX3 = 7'b1111111;
assign HEX2 = 7'b1111111;
assign HEX1 = 7'b1111111;
assign HEX0 = 7'b1111111;

assign LEDG[7:0] <= {8{currentState == state1100111}};

always@(posedge ~KEY[3] or posedge ~KEY[0]) begin
	if (~KEY[0]) begin
	      currentState <= reset;
	      register <= 10'b0;
	      LEDR[9:0] <= register[9:0];
	end
	
	else begin
		register <= {register[8:0], SW[0]};
		LEDR[9:0] <= register[9:0];
		case(currentState)
			reset: currentState <= SW[0] ? state1 : reset;
			state1: currentState <= SW[0] ? state11 : reset;
			state11: currentState <= ~SW[0] ? state110 : state11;
			state110: currentState <= ~SW[0] ? state1100 : state1;
			state1100: currentState <= SW[0] ? state11001 : reset;
			state11001: currentState <= SW[0] ? state110011 : reset;
			state110011: currentState <= SW[0] ? state1100111 : state1;
			state1100111: currentState <= SW[0] ? state1 : reset;
			default currentState <= reset;
	
		endcase
	end
end

endmodule	
