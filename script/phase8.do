if [file exists work] {
    vdel -all
}
vlib work
vmap work work

vlog -f script/phase8.f

vsim -c tbench_top
run -all

quit -f