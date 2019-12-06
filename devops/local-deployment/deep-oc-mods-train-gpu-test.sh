#!/usr/bin/env bash

if [ $# -eq 0 ]; then
	echo """\
usage: $0 [-h] [--model_file MODEL_FILE]
                [--data_select_query DATA_SELECT_QUERY]
                [--train_time_range TRAIN_TIME_RANGE]
                [--train_time_ranges_excluded TRAIN_TIME_RANGES_EXCLUDED]
                [--test_time_range TEST_TIME_RANGE]
                [--test_time_ranges_excluded TEST_TIME_RANGES_EXCLUDED]
                [--window_slide WINDOW_SLIDE] [--sequence_len SEQUENCE_LEN]
                [--model_delta MODEL_DELTA] [--steps_ahead STEPS_AHEAD]
                [--model_type MODEL_TYPE] [--num_epochs NUM_EPOCHS]
                [--epochs_patience EPOCHS_PATIENCE] [--blocks BLOCKS]
                [--stacked_blocks STACKED_BLOCKS] [--batch_size BATCH_SIZE]
                [--batch_normalization BATCH_NORMALIZATION]
                [--dropout_rate DROPOUT_RATE]
                [--bootstrap_data BOOTSTRAP_DATA]
"""
	exit 0
fi

docker exec -t deep-oc-mods-gpu-test python /srv/mods/mods/models/train.py $*
