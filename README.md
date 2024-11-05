
A slightly modified version of the IQ cores of [LSF](https://gitlab.com/librespacefoundation/fpga-cores/-/tree/master?ref_type=heads) to allow the use of a gpio. This was achieved by taking out the `mark_sync` and `samp_rate` signals and removing the integrated AXI Lite interface.  

- Changed to system verilog.
- Made code more concise.
- Changed the `mark` and `samp_rate` to be combinational logic, instead of being set only during reset.
