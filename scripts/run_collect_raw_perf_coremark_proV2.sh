#!/usr/bin/env bash
set -Eeuo pipefail

# Caminho fixo dos binários do CoreMark-PRO no Raspberry Pi 2
BIN_DIR="$HOME/coremark-pro/builds/linux32-armv7/gcc/bin"

# Pasta base de saída (com subpasta datada)
OUT_DIR_BASE="$HOME/coremark-pro/perf_logs"

# Número de repetições por executável
RUNS=1

# Sample period (quanto maior, menos amostras → menor arquivo)
SAMPLE_PERIOD=500

ts="$(date +%Y%m%d_%H%M%S)"
OUT_DIR="$OUT_DIR_BASE/run_$ts"
mkdir -p "$OUT_DIR"

echo "[INFO] BIN_DIR=$BIN_DIR"
echo "[INFO] OUT_DIR=$OUT_DIR"
echo "[INFO] RUNS=$RUNS"
echo

# Listar apenas executáveis .exe
mapfile -t EXES < <(find "$BIN_DIR" -maxdepth 1 -type f -name "*.exe" -executable -printf "%f\n" | sort)
[[ "${#EXES[@]}" -gt 0 ]] || { echo "ERRO: Nenhum .exe encontrado em $BIN_DIR"; exit 1; }

pushd "$BIN_DIR" >/dev/null
for exe_base in "${EXES[@]}"; do
  exe_tag="${exe_base//[^A-Za-z0-9._-]/_}"
  workdir="$OUT_DIR/$exe_tag"
  mkdir -p "$workdir"

  echo ">>> Coletando: $exe_base"
  for run_idx in $(seq -w 1 "$RUNS"); do
    data="$workdir/perf_${exe_tag}_r${run_idx}.data"

    perf record -e instructions,branch-instructions,branch-misses,armv7_cortex_a7/branch-loads/,armv7_cortex_a7/branch-load-misses/ -c "$SAMPLE_PERIOD" -o "$data" -- "./$exe_base"   
# A coleta de baixo funcionava aparentemente bem
    #perf record \
 #     -e instructions \
  #    -c "$SAMPLE_PERIOD" \
   #   -o "$data" -- "./$exe_base"

    echo "    [OK]        $(basename "$data")"
  done
  echo
done
popd >/dev/null

echo "[DONE] Arquivos .data em: $OUT_DIR"

