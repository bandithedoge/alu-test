// `timescale 1ns/1ps

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

typedef struct packed {
  logic zero;
  logic parity;
  logic carry;
} flag_t;

module alu_clocked (
    output logic [15:0] out,
    output flag_t flags,
    input logic clk,
    input logic rst,
    input logic [15:0] a,
    input logic [15:0] b,
    input opcode_t select
);
  flag_t flags_next;
  logic [15:0] out_next;

  assign flags_next.zero   = ~|out;
  assign flags_next.parity = ^out;

  always_comb begin
    case (select)
      MOVE: {flags_next.carry, out_next} = {1'b0, b};
      COMP: {flags_next.carry, out_next} = {1'b1, ~b};
      AND:  {flags_next.carry, out_next} = {1'b0, a & b};
      OR:   {flags_next.carry, out_next} = {1'b0, a | b};
      XOR:  {flags_next.carry, out_next} = {1'b0, a ^ b};
      ADD:  {flags_next.carry, out_next} = a + b;
      INCR: {flags_next.carry, out_next} = b + 1;
      SUB:  {flags_next.carry, out_next} = {1'b1, a} - {1'b1, b};
      ROTL: {flags_next.carry, out_next} = {b[15], b[14:0], b[15]};
      LSHL: {flags_next.carry, out_next} = {b[15], b[14:0], 1'b0};
      ROTR: {flags_next.carry, out_next} = {b[0], b[0], b[15:1]};
      LSHR: {flags_next.carry, out_next} = {{2{1'b0}}, b[14:0]};
      XNOR: {flags_next.carry, out_next} = {1'b1, ~(a ^ b)};
      NOR:  {flags_next.carry, out_next} = {1'b1, ~(a | b)};
      DECR: {flags_next.carry, out_next} = {1'b1, b} - {1'b0, 16'd1};
      NAND: {flags_next.carry, out_next} = {1'b1, ~(a & b)};
    endcase
  end

  always_ff @(posedge clk, posedge rst) begin
      if (rst) begin
          out <= 0;
          flags <= 0;
      end
      else begin
          out <= out_next;
          flags <= flags_next;
      end
  end

endmodule
