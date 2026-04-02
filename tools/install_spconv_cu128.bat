@ECHO OFF
CHCP 65001 >NUL 2>&1
SETLOCAL
CD /d %~dp0
SET "PYTHONWARNINGS=ignore"
RMDIR /s /q spconv-gpu >NUL 2>&1
ECHO.
ECHO [----------------------------------------------------------------------------------]
ECHO [                 Install SPCONV (CUDA 12.8) by rathaROG - v0.0.3                  ]
ECHO [----------------------------------------------------------------------------------]
ECHO.
ECHO 🚨 You must manually install Microsoft Visual Studio 2019+ with C++ !
ECHO 🌐 URL: https://visualstudio.microsoft.com/downloads/
ECHO.
ECHO 🚨 You must manually install CUDA 12.8 Toolkit (and cuDNN if needed) !
ECHO 🌐 URL: https://developer.nvidia.com/cuda-12-8-1-download-archive
ECHO.
ECHO 🚨 You must manually install cumm-cu128 !
ECHO 🌐 URL: https://github.com/rathaROG/cumm-gpu
ECHO.
PAUSE
ECHO.
ECHO [INFO] Installing the latest PyTorch for CUDA 12.8 ...
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu128 >NUL 2>&1
ECHO [DONE] PyTorch installed. ✅
ECHO.
ECHO [INFO] Installing build requirements ...
pip install -U pybind11 pccm ccimport ninja build wheel nvidia-arch >NUL 2>&1
ECHO [DONE] All build requirements installed. ✅
ECHO.
ECHO [INFO] Uninstalling existing spconv ...
pip uninstall -y spconv spconv-cu128 spconv-cu126 spconv-cu121 >NUL 2>&1
ECHO [DONE] All spconv uninstalled. ✅
ECHO.
ECHO [INFO] Cloning spconv-gpu repo ...
git clone https://github.com/rathaROG/spconv-gpu.git >NUL 2>&1
CD spconv-gpu
SET CUMM_CUDA_VERSION=12.8
SET CUMM_CUDA_ARCH_LIST=all
SET CUMM_DISABLE_JIT=1
SET CUMM_NVRTC_STD=c++17
SET SPCONV_DISABLE_JIT=1
ECHO [INFO] Activating MSVC environment for spconv ...
call tools\msvc_setup.bat
ECHO [INFO] Building spconv-gpu from source ...
python -m build --wheel --skip-dependency-check --no-isolation >NUL 2>&1
IF EXIST dist\*.whl (
    FOR %%F IN (dist\*.whl) DO pip install "%%F" >NUL 2>&1
    CD ..
    ECHO [DONE] spconv-gpu built and installed. ✅
) ELSE (
    ECHO.
    ECHO [FAIL] spconv-gpu build did not success! ❌
    GOTO BUILDFAIL
)
ECHO.
ECHO [INFO] Testing import
python -c "import spconv;print(spconv.__version__);print(spconv.__file__)"
ECHO [DONE] Test step finished. ✅
ECHO.
ECHO [INFO] Cleaning up ...
RMDIR /s /q spconv-gpu >NUL 2>&1
ECHO.
ECHO [----------------------------------------------------------------------------------]
ECHO [                                     COMPLETE                                     ]
ECHO [----------------------------------------------------------------------------------]
PAUSE
ENDLOCAL
GOTO END

:BUILDFAIL
ECHO.
ECHO [----------------------------------------------------------------------------------]
ECHO [                                       FAIL                                       ]
ECHO [----------------------------------------------------------------------------------]
ECHO.
CD ..
RMDIR /s /q cumm-gpu >NUL 2>&1
RMDIR /s /q spconv-gpu >NUL 2>&1
PAUSE
ENDLOCAL
exit /b 1

:END
