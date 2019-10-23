#!/usr/bin/env bash

MODELS_DIR="/srv/mods/models"
MODEL_NAME="$MODELS_DIR/mods-example-lstm"
DATA_SELECT_QUERY="\
conn|in_count_uid~conn_in|out_count_uid~conn_out;\
dns|in_distinct_query~dns_in_distinct;
ssh|in~ssh_in\
#window_start,window_end\
"
TRAIN_TIME_RANGE="2019-06-01--2019-06-02"
TRAIN_TIME_RANGES_EXCLUDED=""
TEST_TIME_RANGE="2019-06-03--2019-06-03"
TEST_TIME_RANGE_EXCLUDED=""
WINDOW_SLIDE="w01h-s10m"
SEQUENCE_LEN="12"
MODEL_DELTA="True"
STEPS_AHEAD="1"
MODEL_TYPE="LSTM"
NUM_EPOCHS="50"
EPOCHS_PATIENCE="10"
BLOCKS="12"
STACKED_BLOCKS="3"
BATCH_SIZE="1"
BATCH_NORMALIZATION="False"
DROPOUT_RATE="1.0"
BOOTSTRAP_DATA="False"

./deep-oc-mods-train-gpu.sh\
	--model_name "$MODEL_NAME"\
	--data_select_query "$DATA_SELECT_QUERY"\
	--train_time_range "$TRAIN_TIME_RANGE"\
	--test_time_range "'$TEST_TIME_RANGE'"\
	--window_slide "$WINDOW_SLIDE"\
	--sequence_len "$SEQUENCE_LEN"\
	--model_delta "$MODEL_DELTA"\
	--steps_ahead "$STEPS_AHEAD"\
	--model_type "$MODEL_TYPE"\
	--num_epochs "$NUM_EPOCHS"\
	--epochs_patience "$EPOCHS_PATIENCE"\
	--blocks "$BLOCKS"\
	--stacked_blocks "$STACKED_BLOCKS"\
	--batch_size "$BATCH_SIZE"\
	--batch_normalization "$BATCH_NORMALIZATION"\
	--dropout_rate "$DROPOUT_RATE"\
	--bootstrap_data "$BOOTSTRAP_DATA"
