all: i_reader luv_reader rf
.PHONY: all clean i_reader luv_reader rf

i_reader: i_reader_exe
	./i_reader_exe

i_reader_exe: i_reader.v i_reader_tb.v 
	iverilog -o i_reader_exe -Wall i_reader.v i_reader_tb.v 

luv_reader: luv_reader_exe
	./luv_reader_exe

luv_reader_exe: luv_reader.v luv_reader_tb.v 
	iverilog -o luv_reader_exe -Wall luv_reader.v luv_reader_tb.v 

rf: rf_exe
	./rf_exe

rf_exe: rf.v rf_tb.v mux_lib.v
	iverilog -o rf_exe -Wall rf.v rf_tb.v mux_lib.v

clean:
	rm -f *_exe *.vcd
