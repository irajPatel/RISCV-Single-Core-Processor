module Main_Decoder(Op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp);
    // Inputs and outputs declaration
    input [6:0] Op;                // 7-bit opcode input signal
    output RegWrite, ALUSrc, MemWrite, ResultSrc, Branch; // Control signals
    output [1:0] ImmSrc, ALUOp;    // 2-bit output signals for immediate source and ALU operation

    // The design uses combinational logic to avoid delays associated with sequential circuits.
    // This ensures outputs are updated as soon as the inputs (Op) change.

    // RegWrite is set high for instructions that require writing data back to a register.
    // These include:
    // - Load instructions (Op = 7'b0000011)
    // - R-type instructions (Op = 7'b0110011)
    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0110011) ? 1'b1 : 1'b0;

    // ImmSrc selects the immediate value type based on the instruction type:
    // - S-type instructions (Op = 7'b0100011) select 2'b01
    // - B-type instructions (Op = 7'b1100011) select 2'b10
    // - Default (I-type) instructions select 2'b00
    assign ImmSrc = (Op == 7'b0100011) ? 2'b01 : 
                    (Op == 7'b1100011) ? 2'b10 :    
                                         2'b00;

    // ALUSrc determines if the ALU operand comes from immediate data (1) or a register (0):
    // - Load/store instructions (Op = 7'b0000011, 7'b0100011) use immediate data
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011) ? 1'b1 : 1'b0;

    // MemWrite enables memory write operations for store instructions:
    // - S-type instructions (Op = 7'b0100011) perform memory write
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 : 1'b0;

    // ResultSrc determines the source of the result to be written back:
    // - Load instructions (Op = 7'b0000011) use data from memory (1)
    // - Default (e.g., ALU operations) use ALU result (0)
    assign ResultSrc = (Op == 7'b0000011) ? 1'b1 : 1'b0;

    // Branch is high for branch instructions:
    // - B-type instructions (Op = 7'b1100011) perform conditional branching
    assign Branch = (Op == 7'b1100011) ? 1'b1 : 1'b0;

    // ALUOp determines the ALU operation type:
    // - R-type instructions (Op = 7'b0110011) select 2'b10 for specific ALU operations
    // - B-type instructions (Op = 7'b1100011) select 2'b01 for comparison
    // - Default selects 2'b00 for basic operations (e.g., addition)
    assign ALUOp = (Op == 7'b0110011) ? 2'b10 :
                   (Op == 7'b1100011) ? 2'b01 :
                                        2'b00;

endmodule
