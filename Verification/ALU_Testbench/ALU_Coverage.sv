class ALU_Coverage;

  ALU_Transaction tr;   // the covergroup reads from this handle

  covergroup alu_cg;
    option.per_instance = 1;
    option.name         = "alu_cg";

    // ---------- Opcode ----------
    cp_op : coverpoint tr.ALUControlE {
      bins ADD  = {4'b0000};
      bins SUB  = {4'b0001};
      bins SLL  = {4'b0010};
      bins SLT  = {4'b0011};
      bins SLTU = {4'b0100};
      bins XOR  = {4'b0101};
      bins SRL  = {4'b0110};
      bins SRA  = {4'b0111};
      bins OR   = {4'b1000};
      bins AND  = {4'b1001};
      bins invalid[] = {[4'b1010:4'b1111]};  // DUT defaults to 0; remove if you never drive these
    }

    // ---------- Operand classes ----------
    cp_A : coverpoint tr.SrcAE {
      bins zero      = {32'h0000_0000};
      bins one       = {32'h0000_0001};
      bins small_pos = {[32'h2 : 32'hFF]};
      bins mid_pos   = {[32'h100 : 32'h7FFF_FFFE]};
      bins max_pos   = {32'h7FFF_FFFF};
      bins min_neg   = {32'h8000_0000};
      bins neg       = {[32'h8000_0001 : 32'hFFFF_FFFE]};
      bins all_ones  = {32'hFFFF_FFFF};
    }

    cp_B : coverpoint tr.SrcBE {
      bins zero      = {32'h0000_0000};
      bins one       = {32'h0000_0001};
      bins small_pos = {[32'h2 : 32'hFF]};
      bins mid_pos   = {[32'h100 : 32'h7FFF_FFFE]};
      bins max_pos   = {32'h7FFF_FFFF};
      bins min_neg   = {32'h8000_0000};
      bins neg       = {[32'h8000_0001 : 32'hFFFF_FFFE]};
      bins all_ones  = {32'hFFFF_FFFF};
    }

    cp_signA : coverpoint tr.SrcAE[31];
    cp_signB : coverpoint tr.SrcBE[31];

    // A == B, A < B, A > B (unsigned)
    cp_rel : coverpoint {(tr.SrcAE == tr.SrcBE), (tr.SrcAE < tr.SrcBE)} {
      bins equal   = {2'b10};
      bins less    = {2'b01};
      bins greater = {2'b00};
    }

    // Shift amount (only the low 5 bits of SrcBE are used)
    cp_shamt : coverpoint tr.SrcBE[4:0] {
      bins zero  = {0};
      bins one   = {1};
      bins mid   = {[2:30]};
      bins max   = {31};
    }

    // ---------- Observed outputs (flags) ----------
    cp_Z   : coverpoint tr.Z;
    cp_N   : coverpoint tr.N;
    cp_OV  : coverpoint tr.OV;
    cp_CY  : coverpoint tr.CY;
    cp_lts : coverpoint tr.lts;
    cp_ltu : coverpoint tr.ltu;

    // ---------- Crosses ----------
    // Every opcode with every operand class
    x_op_A  : cross cp_op, cp_A  { ignore_bins inv = binsof(cp_op.invalid); }
    x_op_B  : cross cp_op, cp_B  { ignore_bins inv = binsof(cp_op.invalid); }

    // ADD/SUB: operand signs x overflow x carry
    x_addsub : cross cp_op, cp_signA, cp_signB, cp_OV, cp_CY {
      ignore_bins other_ops = !binsof(cp_op.ADD) && !binsof(cp_op.SUB);
    }

    // Shifts: opcode x shift amount
    x_shift : cross cp_op, cp_shamt {
      ignore_bins not_shift = !binsof(cp_op.SLL) &&
                              !binsof(cp_op.SRL) &&
                              !binsof(cp_op.SRA);
    }

    // Compare ops: opcode x relation of A and B
    x_cmp : cross cp_op, cp_rel {
      ignore_bins not_cmp = !binsof(cp_op.SLT) &&
                            !binsof(cp_op.SLTU) &&
                            !binsof(cp_op.SUB);
    }

    // Opcode x result flags
    x_op_Z : cross cp_op, cp_Z { ignore_bins inv = binsof(cp_op.invalid); }
    x_op_N : cross cp_op, cp_N { ignore_bins inv = binsof(cp_op.invalid); }
  endgroup

  function new();
    alu_cg = new();     // embedded covergroups must be constructed here
  endfunction

  // Called once per observed transaction (inputs + DUT outputs)
  function void sample(ALU_Transaction t);
    tr = t;
    alu_cg.sample();
  endfunction

  function void report();
    $display("[COV] Functional coverage = %0.2f %%", alu_cg.get_coverage());
  endfunction

endclass