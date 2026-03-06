typedef enum logic [1:0] {
    ADD = 2'b00,
    SUB = 2'b01,
    MUL = 2'b10,
    XOR = 2'b11
} opcode_t;

class Transaction;

    rand bit [7:0] a;
    rand bit [7:0] b;
    rand opcode_t opcode;

    constraint mul_freq {
        opcode dist {
            ADD := 25,
            SUB := 25,
            XOR := 25,
            MUL := 25
        };
    }

endclass


module tb;

logic [7:0] a;
logic [7:0] b;
logic [1:0] opcode;
logic [15:0] y;

Transaction tr;

alu dut(
    .a(a),
    .b(b),
    .opcode(opcode),
    .y(y)
);

////////////////////////
// COVERAGE
////////////////////////

covergroup cg;

    cp_opcode : coverpoint opcode {
        bins add = {0};
        bins sub = {1};
        bins mul = {2};
        bins xor_op = {3};
    }

endgroup

cg cov = new();

////////////////////////

initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0,tb);

    tr = new();

    repeat(20) begin

        tr.randomize();

        a = tr.a;
        b = tr.b;
        opcode = tr.opcode;

        #5;

        cov.sample();   // THIS COLLECTS COVERAGE

        $display("A=%0d B=%0d OPCODE=%0d RESULT=%0d",a,b,opcode,y);

    end

    $display("Coverage = %0.2f %%", cov.get_coverage());

    $finish;

end

endmodule
