#!/bin/bash

# Periksa apakah setidaknya satu argumen diberikan
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <input-file> [prefix]"
    exit 1
fi

# Ambil file input dari argumen pertama
INPUT_FILE="$1"

# Ambil prefix dari argumen kedua (default: "////")
PREFIX="${2:-////}"

# Periksa apakah file input ada
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File '$INPUT_FILE' tidak ditemukan!"
    exit 1
fi

# Buat pola regex berdasarkan prefix
PREFIX_ESCAPED=$(echo "$PREFIX" | sed 's/[]\/$*.^[]/\\&/g')

# Cari baris yang mengandung "<prefix> out:" dan ekstrak path output
OUTPUT_PATH=$(grep -oP "^\s*$PREFIX_ESCAPED out:\s*\"\K[^\"]+" "$INPUT_FILE")

# Jika path output tidak ditemukan, berikan pesan error
if [[ -z "$OUTPUT_PATH" ]]; then
    echo "Error: Tidak ditemukan path output dalam file!"
    exit 1
fi

# Buat direktori jika belum ada
mkdir -p "$(dirname "$OUTPUT_PATH")"

# Hapus "<prefix>" di awal baris dan hapus baris "<prefix> out: ..."
grep -v "^\s*$PREFIX_ESCAPED out:" "$INPUT_FILE" | sed -E "s/^\s*$PREFIX_ESCAPED ?//" > "$OUTPUT_PATH"

echo "Berhasil diproses! Hasil disimpan di: $OUTPUT_PATH"

# Ambil nama file saja (misal: output.md)
FILENAME=$(basename "$OUTPUT_PATH")

# Ambil nama tanpa ekstensi (misal: output)
NAME="${FILENAME%.*}"

# Cetak dalam format yang diinginkan
echo "{ text: '$NAME', link: '$OUTPUT_PATH' }"
