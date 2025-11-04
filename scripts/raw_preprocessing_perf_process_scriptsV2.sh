#!/usr/bin/env bash
set -Eeuo pipefail

# Pasta raiz onde o perf_coremark_pro.sh salva os resultados
ROOT_DIR="$HOME/coremark-pro/perf_logs/run_20250911_173922"

echo "[INFO] Procurando arquivos .data em: $ROOT_DIR"
echo

# Encontrar todos os .data
mapfile -t DATAFILES < <(find "$ROOT_DIR" -type f -name "*.data" | sort)
[[ "${#DATAFILES[@]}" -gt 0 ]] || { echo "ERRO: Nenhum arquivo .data encontrado"; exit 1; }

for data in "${DATAFILES[@]}"; do
  workdir="$(dirname "$data")"
  base="$(basename "$data" .data)"

  trace_out="$workdir/trace.txt"
  itrace_out="$workdir/itrace.txt"

  echo ">>> Processando: $data"
  # Dump textual das amostras (sem fluxo de instruções)
  perf script -i "$data" -F +time,+event,+period,+ip,+sym,+dso > "$trace_out"

  # Só linhas de branch (útil para separar)
  grep -E 'branch-(instructions|misses)|armv7_cortex_a7/branch-(loads|load-misses)/' "$trace_out" > "$itrace_out"
  # instruções + calls/returns + branches
#  sudo perf script --itrace=ibcr -F +insn,+disasm,+insnlen,+sym,+dso -i "$data" > "$trace_out" 
  # somente branches com flags
 # sudo perf script --itrace=b -F +ip,+sym,+flags -i "$data" > "$itrace_out"

  # Gerar trace detalhado (instruções)
  #perf script --itrace=i -i "$data" > "$trace_out" || true

  # Gerar fluxo de branches/saltos
 # perf script --itrace=yb -i "$data" > "$itrace_out" || true

  echo "    [OK] � $trace_out , $itrace_out"
  echo
done

echo "[DONE] Todos os arquivos processados."
