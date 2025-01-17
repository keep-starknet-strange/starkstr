#!/bin/bash

################################################################################
# Congiguration
################################################################################
readonly LAYOUT=starknet
readonly PROFILE=proving
readonly PROGRAM_DIR="packages/aggsig_checker/target/proving"
readonly PROGRAM_NAME=aggsig_checker
readonly CFG_AND_PARAMS_DIR=config_and_params
readonly TRACE_OUTPUT_DIR=outputs/$PROGRAM_NAME/trace
readonly PIE_OUTPUT_DIR=outputs/$PROGRAM_NAME/pie
readonly PROOF_OUTPUT_DIR=outputs/$PROGRAM_NAME/proof
readonly CAIRO_RUN_BIN="cairo1-run"
readonly STWO_PROVER_BIN="adapted_stwo"

readonly PROGRAM_ARGS="[251912467096364154057891175458070492549 260939768651009451376603063044198637691 77051329489827983386539320026376488593 143855497612595372087158556956488272703 188623336253429538540807746188656707437 287350745678731217637630315430431928781 223834982005398908649898595952193718522 280017917956868261785908066628339915890]"

mkdir -p $PROOF_OUTPUT_DIR
mkdir -p $PIE_OUTPUT_DIR
mkdir -p $TRACE_OUTPUT_DIR


################################################################################
# Build the Cairoprogram
################################################################################
cd packages/aggsig_checker
scarb --profile $PROFILE build
cd ../..

################################################################################
# Generate the Cairo-Pie
################################################################################
#echo "Generating Cairo-Pie"
CMD="$CAIRO_RUN_BIN $PROGRAM_DIR/$PROGRAM_NAME.sierra.json \
  --layout=$LAYOUT \
  --args \"$PROGRAM_ARGS\" 
  --cairo_pie_output=$PIE_OUTPUT_DIR/cairo-pie.zip"
echo $CMD
eval $CMD

################################################################################
#echo "Generating Trace"
#$CAIRO_RUN_BIN $PROGRAM_DIR/$PROGRAM_NAME.sierra.json \
#  --args "$PROGRAM_ARGS" \
#  --layout=$LAYOUT \
#  --air_public_input=$TRACE_OUTPUT_DIR/public-input.json \
#  --air_private_input=$TRACE_OUTPUT_DIR/private-input.json \
#  --trace_file=$TRACE_OUTPUT_DIR/trace.bin \
#  --memory_file=$TRACE_OUTPUT_DIR/memory.bin \
#  --proof_mode 

################################################################################
# Generate the Proof
################################################################################
#echo "Generating Proof"
#$STWO_PROVER_BIN --pub_json $TRACE_OUTPUT_DIR/public-input.json --priv_json $TRACE_OUTPUT_DIR/private-input.json --proof_path stwo-proof.json --verify
