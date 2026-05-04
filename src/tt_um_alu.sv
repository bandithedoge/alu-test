typedef enum logic [3:0] {
  MOVE = 4'b0000,
  COMP = 4'b0001,
  AND  = 4'b0010,
  OR   = 4'b0011,
  XOR  = 4'b0100,
  ADD  = 4'b0101,
  INCR = 4'b0110,
  SUB  = 4'b0111,
  ROTL = 4'b1000,
  LSHL = 4'b1001,
  ROTR = 4'b1010,
  LSHR = 4'b1011,
  XNOR = 4'b1100,
  NOR  = 4'b1101,
  DECR = 4'b1110,
  NAND = 4'b1111
} opcode_t;

module tt_um_alu (
    output logic [15:0] aluout,
    output logic zero,
    output logic parity,
    output logic carry,
    input logic [15:0] a,
    input logic [15:0] b,
    input opcode_t select
);
  assign zero   = ~|aluout;
  assign parity = ^aluout;

  always_comb begin
    case (select)
      MOVE: {carry, aluout} = {1'b0, b};
      COMP: {carry, aluout} = {1'b1, ~b};
      AND:  {carry, aluout} = {1'b0, a & b};
      OR:   {carry, aluout} = {1'b0, a | b};
      XOR:  {carry, aluout} = {1'b0, a ^ b};
      ADD:  {carry, aluout} = a + b;
      INCR: {carry, aluout} = b + 1;
      SUB:  {carry, aluout} = {1'b1, a} - {1'b1, b};
      ROTL: {carry, aluout} = {b[15], b[14:0], b[15]};
      LSHL: {carry, aluout} = {b[15], b[14:0], 1'b0};
      ROTR: {carry, aluout} = {b[0], b[0], b[15:1]};
      LSHR: {carry, aluout} = {{2{1'b0}}, b[14:0]};
      XNOR: {carry, aluout} = {1'b1, ~(a ^ b)};
      NOR:  {carry, aluout} = {1'b1, ~(a | b)};
      DECR: {carry, aluout} = {1'b1, b} - {1'b0, 16'd1};
      NAND: {carry, aluout} = {1'b1, ~(a & b)};
    endcase
  end

endmodule
