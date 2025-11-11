module top (
  // I/O ports
  input  logic hwclk, reset, //hwclk = 10 MHz
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

logic [3:0] count;
logic count_enable, count_clear, count_overflow;

counter count0(.clk(hwclk), .nrst(reset), .enable(count_enable), .clear(count_clear), .count(count), .overflow_flag(count_overflow));

endmodule