# SpConv-GPU

This repo is just a fork from `SpConv` — [Spatially Sparse Convolution library](https://github.com/traveller59/spconv).

## ⬇️ Install

Before you install, you must uninstall all existing versions to avoid conflicts:

```bash
pip uninstall -y spconv spconv-cu130 spconv-cu128 spconv-cu126 spconv-cu121 
```

For easy installation using prebuilt wheels (example for CUDA 13.0):

```bash
pip install spconv-cu130 --extra-index-url https://ratharog.github.io/cumm-spconv/
```

See [ratharog.github.io/cumm-spconv](https://ratharog.github.io/cumm-spconv/) for prebuilt wheel info and supported CUDA versions.

## 🛠️ Build and install from source

Building from source requires:
- A C++ compiler
- CUDA Toolkit installed (for CUDA support)

### On Linux with CUDA 13.0:

```bash
export CUMM_CUDA_VERSION="13.0"
export CUMM_CUDA_ARCH_LIST="all"
export CUMM_DISABLE_JIT="1"
export SPCONV_DISABLE_JIT="1"
pip install cumm-cu130 --extra-index-url https://ratharog.github.io/cumm-spconv/
pip install git+https://github.com/rathaROG/spconv-gpu.git
```

### On Windows with CUDA 13.0 + MSVC 2019 (cmd terminal):

Due to unknown reasons, `pip install git+https://github.com/rathaROG/spconv-gpu.git` **often fails to build on Windows**. Building a wheel with [build](https://pypi.org/project/build/) and [wheel](https://pypi.org/project/wheel/) is more reliable:

```cmd
pip install -U pybind11 pccm ccimport ninja build wheel
git clone https://github.com/rathaROG/spconv-gpu.git
cd spconv-gpu
tools\msvc_setup.bat
SET CUMM_CUDA_VERSION=13.0
SET CUMM_CUDA_ARCH_LIST=all
SET CUMM_DISABLE_JIT=1
SET SPCONV_DISABLE_JIT=1
pip install cumm-cu130 --extra-index-url https://ratharog.github.io/cumm-spconv/
python -m build --wheel --skip-dependency-check --no-isolation
for %f in (dist\*.whl) do pip install "%f"
```

### On any platform with CPU only:

```bash
pip install git+https://github.com/rathaROG/spconv-gpu.git
```

**Note**: 

- For detailed build logs, add `--verbose` to the `pip install` command.
- On Windows, you can also use the scripts below to build and install from source; feel free to modify:
  - For CUDA 12.8: [install_spconv_cu128.bat](https://github.com/rathaROG/spconv-gpu/blob/main/tools/install_spconv_cu128.bat)
  - For CUDA 13.0: [install_spconv_cu130.bat](https://github.com/rathaROG/spconv-gpu/blob/main/tools/install_spconv_cu130.bat)

## 📝 License

[![LICENSE](https://img.shields.io/badge/LICENSE-Apache_2.0-blue)](LICENSE)
