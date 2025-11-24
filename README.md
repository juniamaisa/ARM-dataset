# **README.md**

# ARM Instruction-Trace Dataset (Raspberry Pi 2, CoreMark-PRO)

This repository provides a collection of **raw processor-level execution traces** obtained from a **Raspberry Pi 2 Model B** using the Linux tool **perf** during the execution of **CoreMark-PRO** workloads.
The dataset is intended to support research on **control-flow analysis**, **program behavior modeling**, and **advanced code-reuse attack detection** based on hardware-level execution traces.

All files in this repository are provided **exactly as recorded** by `perf` (binary `.data` format), without any preprocessing.

---

## 1. Overview

The goal of this dataset is to provide reproducible, real-device traces capturing:

* low-level processor behavior
* instruction-level execution flow
* branch activity and dynamic control patterns
* variability across different CoreMark-PRO workloads

These traces can be used to build and evaluate models in:

* anomaly detection
* code-reuse attack detection
* instruction-trace analysis
* microarchitectural behavior characterization
* lightweight deep learning for embedded security

This dataset was originally collected for research on **deep neural network–based code-reuse attack detection**, and it has been shared to support independent verification, comparison and follow-up studies.

---

## 2. Hardware and Software Environment

The data was collected on:

* **Board:** Raspberry Pi 2 Model B
* **Processor:** ARM Cortex-A7, quad-core, 900 MHz
* **Architecture:** ARMv7-A
* **Operating System:** *[to be added]*
* **Kernel Version:** *[to be added]*
* **perf Version:** *[to be added]*

This section will be updated when the exact version strings are inserted.

---

## 3. Data Collection Procedure

All traces were collected using the script:

```
scripts/run_collect_raw_perf_coremark_proV2.sh
```

This script performs the following steps:

1. Executes each CoreMark-PRO workload on the Raspberry Pi 2.
2. Uses `perf` to record processor-level events in **raw binary format**.
3. Produces one output file per run:

   ```
   perf_<workload>_r1.data
   perf_<workload>_r2.data
   ```
4. Stores the recordings inside a folder corresponding to the workload name.

Two perf recordings (`r1` and `r2`) were generated for each workload.
Only **r1** was used in the associated publication, but both are preserved for reproducibility.

---

## 4. Dataset Structure

The root of the repository contains one directory per **CoreMark-PRO workload**:

```
cjpeg-rose7-preset.exe/
core.exe/
linear_alg-mid-100x100-sp.exe/
loops-all-mid-10k-sp.exe/
nnet_test.exe/
parser-125k.exe/
radix2-big-64k.exe/
sha-test.exe/
zip-test.exe/
scripts/
README.md
```

### Inside each workload directory

Example:

```
cjpeg-rose7-preset.exe/
 ├── perf_cjpeg-rose7-preset.exe_r1.data    # Raw perf recording (run 1)
 └── perf_cjpeg-rose7-preset.exe_r2.data    # Raw perf recording (run 2)
```

All files are **unaltered `.data` binaries** generated directly by `perf record`.

### Scripts directory

```
scripts/
 ├── run_collect_raw_perf_coremark_proV2.sh
 └── raw_preprocessing_perf_process_scriptsV2.sh
```

**run_collect_raw_perf_coremark_proV2.sh**
Automates the execution of CoreMark-PRO benchmarks under `perf`, producing the raw `.data` files.

**raw_preprocessing_perf_process_scriptsV2.sh**
Provides optional tools for:

* converting `.data` to text (via `perf script`)
* extracting relevant fields
* preparing data for further processing (.txt)

These processing steps were **not** applied to the dataset included here.

---

## 5. Benchmarks Included

All workloads derive from **CoreMark-PRO**, a standardized benchmark suite targeting embedded processors.

The dataset includes the following workloads:

* cjpeg-rose7-preset
* core
* linear_alg-mid-100x100-sp
* loops-all-mid-10k-sp
* nnet_test
* parser-125k
* radix2-big-64k
* sha-test
* zip-test

Each contains:

* 2 raw perf recordings (r1, r2)
* corresponding to full workload execution

---

## 6. Intended Use

This dataset enables research in:

* control-flow modeling
* anomaly detection methods
* instruction-trace learning
* detection of code-reuse attacks (ROP, JOP, COP)
* statistical or machine-learning models for embedded devices
* dynamic behavior characterization of ARM Cortex-A7 processors

The traces come from normal (benign) CoreMark-PRO executions.

---

## 7. How to Process the Data

The dataset is raw. To process it:

### Convert perf data to human-readable trace

```
perf script -i perf_<workload>_r1.data > out.txt
```


## 8. Citation

If you use this dataset, please cite the following publication:

**J. M. Oliveira, A. Musa, E. Parisi, F. Barchi and A. Acquaviva**,
*“Deep Neural Networks Study for Advanced Code-reuse Attacks Detection,”*
**2025 IEEE 9th Forum on Research and Technologies for Society and Industry (RTSI)**, Tunis, Tunisia, 2025, pp. 332–337.
doi: **10.1109/RTSI64020.2025.11212515**

A BibTeX entry is also provided:

```
@inproceedings{oliveira2025deep,
  author={Oliveira, J. M. and Musa, A. and Parisi, E. and Barchi, F. and Acquaviva, A.},
  title={Deep Neural Networks Study for Advanced Code-reuse Attacks Detection},
  booktitle={2025 IEEE 9th Forum on Research and Technologies for Society and Industry (RTSI)},
  year={2025},
  pages={332--337},
  doi={10.1109/RTSI64020.2025.11212515}
}
```

---

## 9. License

This dataset is released under the **Apache 2.0 License**.

See `LICENSE` for details.

---

## 10. Contact

For questions, please open an issue on this repository.

junia.deoliveira@unibo.it
