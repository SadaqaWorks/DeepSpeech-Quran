#!/bin/sh
set -xe
if [ ! -f DeepSpeech.py ]; then
    echo "Please make sure you run this from DeepSpeech's top level directory."
    exit 1
fi;

if [ ! -d "${COMPUTE_DATA_DIR}" ]; then
    COMPUTE_DATA_DIR="data/quran"
fi;

# Warn if we can't find the train files
if [ ! -f "${COMPUTE_DATA_DIR}/quran_train.csv" ]; then
    echo "Warning: It looks like you don't have the Quran corpus downloaded"\
         "and preprocessed. Make sure \$COMPUTE_DATA_DIR points to the folder where"\
         "the Quran data is located, and that you ran the" \
         "importer script at bin/import_quran.py before running this script."
fi;

if [ -d "${COMPUTE_KEEP_DIR}" ]; then
    checkpoint_dir=$COMPUTE_KEEP_DIR
else
    checkpoint_dir=$(python -c 'from xdg import BaseDirectory as xdg; print(xdg.save_data_path("deepspeech/quran"))')
fi

python -u DeepSpeech.py \
  --train_files "$COMPUTE_DATA_DIR/quran_train.csv" \
  --dev_files "$COMPUTE_DATA_DIR/quran_dev.csv" \
  --test_files "$COMPUTE_DATA_DIR/quran_test.csv" \
  --alphabet_config_path "$COMPUTE_DATA_DIR/quran-alphabets.txt" \
  #--scorer_path "COMPUTE_DATA_DIR/quran_lm.scorer" \
  --export_dir "$COMPUTE_DATA_DIR" \
  --lm_alpha 1.5 \
  --lm_beta 1.85 \
  --train_batch_size 4 \
  --dev_batch_size 4 \
  --test_batch_size 4 \
  --noearly_stop \
  --epochs 60 \
  --export_language "ar" \
  --n_hidden 1024 \
  --learning_rate 0.0001 \
  --checkpoint_dir "${COMPUTE_DATA_DIR}/../checkpoints" \
  --max_to_keep 2 \
  --checkpoint_secs 1800 \
  "$@"

#  --export_tflite 'true' \

