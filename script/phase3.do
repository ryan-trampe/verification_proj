if [file exists work] {
    vdel -all
}
vlib work
vmap work work

vlog -f script/phase3.f

vsim -c test_fifo
run -all

quit -f