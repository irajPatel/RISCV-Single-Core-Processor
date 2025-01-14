module ALU(A, B, Result, ALUControl, OverFlow, Carry, Zero, Negative);

    // Input and output declaration
    input [31:0] A, B;             // 32-bit inputs A and B for ALU operations
    input [2:0] ALUControl;        // 3-bit control signal to determine the operation
    output Carry, OverFlow, Zero, Negative; // Flags for carry, overflow, zero, and negative
    output [31:0] Result;          // 32-bit result of the ALU operation

    wire Cout;                     // Intermediate carry-out signal
    wire [31:0] Sum;               // Intermediate sum for addition or subtraction

    // Arithmetic operation: Addition or Subtraction
    // - If ALUControl[0] is 0, perform addition: A + B
    // - If ALUControl[0] is 1, perform subtraction: A - B
    //   Subtraction is implemented as A + (~B + 1) using 2's complement
    assign {Cout, Sum} = (ALUControl[0] == 1'b0) ? A + B :
                                              A + ((~B) + 1);

    // Result logic based on ALUControl:
    // - ALUControl 000: Addition result
    // - ALUControl 001: Subtraction result
    // - ALUControl 010: Bitwise AND
    // - ALUControl 011: Bitwise OR
    // - ALUControl 101: Set Less Than (SLT), where Result = 1 if A < B
    // - Default: Result = 0
    assign Result = (ALUControl == 3'b000) ? Sum :
                    (ALUControl == 3'b001) ? Sum :
                    (ALUControl == 3'b010) ? A & B :
                    (ALUControl == 3'b011) ? A | B :
                    (ALUControl == 3'b101) ? {{31{1'b0}}, (Sum[31])} : {32{1'b0}};

    // Overflow detection:
    // - Overflow occurs if the MSB of the result (Sum[31]) is incorrect:
    //   - For addition, check if Sum[31] differs from both A[31] and B[31]
    //   - For subtraction, consider the 2's complement operation
    // - Overflow is only valid for arithmetic operations (ALUControl[1:0] == 2'b00 or 2'b01)
    assign OverFlow = ((Sum[31] ^ A[31]) & 
                      (~(ALUControl[0] ^ B[31] ^ A[31])) & 
                      (~ALUControl[1]));

    // Carry flag:
    // - Valid only for arithmetic operations (ALUControl[1] == 0)
    // - Carry is set when Cout (carry-out from MSB) is 1
    assign Carry = ((~ALUControl[1]) & Cout);

    // Zero flag:
    // - Set to 1 if all bits of the result are 0
    assign Zero = &(~Result);

    // Negative flag:
    // - Set to 1 if the result's MSB (sign bit) is 1, indicating a negative result
    assign Negative = Result[31];

endmodule
