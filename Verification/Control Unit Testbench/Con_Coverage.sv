class Con_Coverage;

    Con_Transaction tr;

    covergroup Con_cg;

        option.per_instance = 1;
        option.name = "Con_cg";

        // ================================================
        // 1. Opcode Coverage
        // ================================================

        cp_Op : coverpoint tr.OpD {
            bins LOAD   = {7'd3};
            bins I_TYPE = {7'd19};
            bins AUIPC  = {7'd23};
            bins STORE  = {7'd35};
            bins R_TYPE = {7'd51};
            bins LUI    = {7'd55};
            bins BRANCH = {7'd99};
            bins JALR   = {7'd103};
            bins JAL    = {7'd111};
        }

        // ================================================
        // 2. R-Type Instruction Coverage
        // ================================================

        cp_R_Type : coverpoint {tr.funct3D, tr.funct7b5D}
                    iff (tr.OpD == 7'd51) {

            bins ADD  = {4'b0000};
            bins SUB  = {4'b0001};
            bins SLL  = {4'b0010};
            bins SLT  = {4'b0100};
            bins SLTU = {4'b0110};
            bins XOR  = {4'b1000};
            bins SRL  = {4'b1010};
            bins SRA  = {4'b1011};
            bins OR   = {4'b1100};
            bins AND  = {4'b1110};
        }

        // ================================================
        // 3. I-Type Instruction Coverage
        // ================================================

        cp_I_Type : coverpoint {tr.funct3D, tr.funct7b5D}
                    iff (tr.OpD == 7'd19) {

            wildcard bins ADDI  = {4'b000?};
                     bins SLLI  = {4'b0010};
            wildcard bins SLTI  = {4'b010?};
            wildcard bins SLTIU = {4'b011?};
            wildcard bins XORI  = {4'b100?};
                     bins SRLI  = {4'b1010};
                     bins SRAI  = {4'b1011};
            wildcard bins ORI   = {4'b110?};
            wildcard bins ANDI  = {4'b111?};
        }

        // ================================================
        // 4. Load Instruction Coverage
        // ================================================

        cp_Load : coverpoint tr.funct3D
                  iff (tr.OpD == 7'd3) {

            bins LB  = {3'b000};
            bins LH  = {3'b001};
            bins LW  = {3'b010};
            bins LBU = {3'b100};
            bins LHU = {3'b101};
        }

        // ================================================
        // 5. Store Instruction Coverage
        // ================================================

        cp_Store : coverpoint tr.funct3D
                   iff (tr.OpD == 7'd35) {

            bins SB = {3'b000};
            bins SH = {3'b001};
            bins SW = {3'b010};
        }

        // ================================================
        // 6. Branch Decode Coverage
        // ================================================

        cp_BranchD : coverpoint tr.funct3D
                     iff (tr.OpD == 7'd99) {

            bins BEQ  = {3'b000};
            bins BNE  = {3'b001};
            bins BLT  = {3'b100};
            bins BGE  = {3'b101};
            bins BLTU = {3'b110};
            bins BGEU = {3'b111};
        }

        // ================================================
        // 7. ALU Control Coverage
        // ================================================

        cp_ALUControlD : coverpoint tr.ALUControlD {

            bins ADD  = {4'd0};
            bins SUB  = {4'd1};
            bins SLL  = {4'd2};
            bins SLT  = {4'd3};
            bins SLTU = {4'd4};
            bins XOR  = {4'd5};
            bins SRL  = {4'd6};
            bins SRA  = {4'd7};
            bins OR   = {4'd8};
            bins AND  = {4'd9};
        }

        // ================================================
        // 8. Main Decoder Output Coverage
        // ================================================

        cp_RegWriteD : coverpoint tr.RegWriteD;
        cp_MemWriteD : coverpoint tr.MemWriteD;
        cp_JumpD     : coverpoint tr.JumpD;
        cp_BranchEnD : coverpoint tr.BranchD;
        cp_ALUSrcD   : coverpoint tr.ALUSrcD;

        cp_ResultSrc : coverpoint tr.ResultSrcD {

            bins ALUResult = {3'b000};
            bins ReadData  = {3'b001};
            bins PCPlus4   = {3'b010};
            bins PCTarget  = {3'b011};
            bins ImmExt    = {3'b100};
        }

        cp_ImmSrcD : coverpoint tr.ImmSrcD
                     iff (tr.OpD != 7'd51) {

            bins I_TYPE = {3'b000};
            bins S_TYPE = {3'b001};
            bins B_TYPE = {3'b010};
            bins U_TYPE = {3'b011};
            bins J_TYPE = {3'b100};
        }

        // ================================================
        // 9. Execution Stage Input Coverage
        // ================================================

        cp_JumpE   : coverpoint tr.JumpE;
        cp_BranchE : coverpoint tr.BranchE;

        cp_Z   : coverpoint tr.Z;
        cp_lts : coverpoint tr.lts;
        cp_ltu : coverpoint tr.ltu;

        // ================================================
        // 10. PCSrcE Coverage
        // ================================================

        cp_PCSrcE : coverpoint tr.PCSrcE {

            bins PCPlus4   = {2'b00};
            bins PCTarget  = {2'b01};
            bins ALUResult = {2'b10};

            illegal_bins invalid = {2'b11};
        }

        // ================================================
        // 11. Branch Execution Coverage
        // ================================================

        cp_BranchTypeE : coverpoint tr.funct3E
                         iff (tr.BranchE && !tr.JumpE) {

            bins BEQ  = {3'b000};
            bins BNE  = {3'b001};
            bins BLT  = {3'b100};
            bins BGE  = {3'b101};
            bins BLTU = {3'b110};
            bins BGEU = {3'b111};
        }

        cp_BranchDecision : coverpoint tr.PCSrcE
                            iff (tr.BranchE && !tr.JumpE) {

            bins NotTaken = {2'b00};
            bins Taken    = {2'b01};
        }

        // ================================================
        // 12. Branch Comparison Flag Coverage
        // ================================================

        cp_BranchFlag : coverpoint (
            (tr.funct3E == 3'b000 ||
             tr.funct3E == 3'b001) ? tr.Z :

            (tr.funct3E == 3'b100 ||
             tr.funct3E == 3'b101) ? tr.lts : tr.ltu

        ) iff (tr.BranchE && !tr.JumpE) {

            bins Low  = {1'b0};
            bins High = {1'b1};
        }

        // ================================================
        // 13. Jump Coverage
        // ================================================

        cp_JumpDecision : coverpoint tr.PCSrcE
                          iff (tr.JumpE && !tr.BranchE) {

            bins DirectJump   = {2'b01};
            bins IndirectJump = {2'b10};
        }

        // ================================================
        // 14. Cross Coverage
        // ================================================

        // Every branch instruction must be taken
        // and not taken at least once
        x_BranchDecision : cross cp_BranchTypeE,
                                 cp_BranchDecision;

        // Every branch instruction must be tested
        // with both comparison flag values
        x_BranchFlag : cross cp_BranchTypeE,
                             cp_BranchFlag;

    endgroup

    // Constructor
    function new();
        Con_cg = new();
    endfunction

    // Sample observed transaction
    function void sample(Con_Transaction t);
        tr = t;
        Con_cg.sample();
    endfunction

    // Functional coverage report
    function void report();
        $display("==========================================");
        $display(" CONTROLLER FUNCTIONAL COVERAGE");
        $display(" Coverage = %0.2f %%",
                 Con_cg.get_inst_coverage());
        $display("==========================================");
    endfunction

endclass