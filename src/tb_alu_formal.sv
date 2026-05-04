module tb_alu_formal;

  logic [15:0] a, b;
  logic [3:0] select;

  logic [15:0] aluout;
  logic zero;
  logic parity;
  logic carry;

  alu dut (
      .a(a),
      .b(b),
      .select(select),
      .aluout(aluout),
      .zero(zero),
      .parity(parity),
      .carry(carry)
  );

  always_comb begin
    assert (zero == (aluout == 16'h0000));
  end

  always_comb begin
    assert (parity == ^aluout);
  end


  always_comb
    if (select == 4'b0000) begin
      assert (aluout == b);
      assert (carry == 1'b0);
    end

  always_comb
    if (select == 4'b0001) begin
      assert (aluout == ~b);
      assert (carry == 1'b1);
    end

  always_comb
    if (select == 4'b0010) begin
      assert ((aluout & ~a) == 16'h0000);
      assert ((aluout & ~b) == 16'h0000);
      assert (carry == 1'b0);
    end

  always_comb
    if (select == 4'b0011) begin
      assert ((aluout | a) == aluout);
      assert ((aluout | b) == aluout);
      assert (carry == 1'b0);
    end

  always_comb
    if (select == 4'b0100) begin
      assert ((aluout ^ b) == a);
      assert (carry == 1'b0);
    end

  always_comb
    if (select == 4'b0101) begin
      logic [16:0] sum;
      sum = a + b;
      assert ({carry, aluout} == sum);
    end

  always_comb
    if (select == 4'b0110) begin
      assert (aluout == (b + 16'd1));
    end

  always_comb
    if (select == 4'b0111) begin
      assert ((aluout + b == a) || (aluout + b + 1 == a));
    end

  always_comb
    if (select == 4'b1000) begin
      assert ($countones(aluout) == $countones(b));
    end

  always_comb
    if (select == 4'b1001) begin
      assert (aluout[0] == 1'b0);
    end

  always_comb
    if (select == 4'b1010) begin
      assert ($countones(aluout) == $countones(b));
    end

  always_comb
    if (select == 4'b1011) begin
      assert (aluout[15] == 1'b0);
    end

  always_comb
    if (select == 4'b1100) begin
      assert (aluout == ~(a ^ b));
      assert (carry == 1'b1);
    end

  always_comb
    if (select == 4'b1101) begin
      assert (aluout == ~(a | b));
      assert (carry == 1'b1);
    end

  always_comb
    if (select == 4'b1110) begin
      assert (aluout + 16'd1 == b);
    end

  always_comb
    if (select == 4'b1111) begin
      assert (aluout == ~(a & b));
      assert (carry == 1'b1);
    end

endmodule
