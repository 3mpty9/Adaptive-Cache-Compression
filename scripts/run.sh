for benchmark in lbm leslie3d astar milc #mcf sjeng namd 
do
    for l2_size in 256kB 1MB 16MB

    do 
        OUTPUT_DIR="results/comp_gcp/$l2_size/$benchmark/"
        C_SIZE = "$l2_size"

        # Check OUTPUT_DIR existence
        if [[ !(-d "$OUTPUT_DIR") ]]; then
            mkdir -p $OUTPUT_DIR
        fi
        SCRIPT_OUT=$OUTPUT_DIR/runscript_file.log

        ./build/ECE565-ARM/gem5.opt -d $OUTPUT_DIR --l2_size="$C_SIZE" configs/spec/spec_se.py \
        --cpu-type=MinorCPU --l1d_size=64kB --l1i_size=64kB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=4 \
        --caches --l2cache  --mem-size=4GB --maxinsts=10000000 -b $benchmark\
        --l2_compressor --gcp --gcp_inc 1 --gcp_dec 2 \
        >> $SCRIPT_OUT

        OUTPUT_DIR="results/comp/$l2_size/$benchmark/"

        # Check OUTPUT_DIR existence
        if [[ !(-d "$OUTPUT_DIR") ]]; then
            mkdir -p $OUTPUT_DIR
        fi
        SCRIPT_OUT=$OUTPUT_DIR/runscript_file.log

        ./build/ECE565-ARM/gem5.opt -d $OUTPUT_DIR --l2_size="$C_SIZE" configs/spec/spec_se.py \
        --cpu-type=MinorCPU --l1d_size=64kB --l1i_size=64kB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=4 \
        --caches --l2cache --mem-size=4GB --maxinsts=10000000 -b $benchmark\
        --l2_compressor \
        >> $SCRIPT_OUT

        OUTPUT_DIR="results/never/$l2_size/$benchmark/"

        # Check OUTPUT_DIR existence
        if [[ !(-d "$OUTPUT_DIR") ]]; then
            mkdir -p $OUTPUT_DIR
        fi
        SCRIPT_OUT=$OUTPUT_DIR/runscript_file.log

        ./build/ECE565-ARM/gem5.opt -d $OUTPUT_DIR --l2_size="$C_SIZE" configs/spec/spec_se.py \
        --cpu-type=MinorCPU --l1d_size=64kB --l1i_size=64kB --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=4 \
        --caches --l2cache --mem-size=4GB --maxinsts=10000000 -b $benchmark\
        >> $SCRIPT_OUT
    done
done
