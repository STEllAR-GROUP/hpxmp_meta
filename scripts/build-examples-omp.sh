# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CLEAN_BUILD=${2:-no}
CURRENT_DIR="${3:-$(realpath "$(dirname "$0")")}"

# Paths setup
PREFIX="$CURRENT_DIR"/..
DEPENDENCIES="${PREFIX}/dependencies"

OMP_INSTALL_PATH="${DEPENDENCIES}/llvm-project/openmp/cmake-install-omp/${BUILD_TYPE}"

SOURCE_PATH="${PREFIX}/hpxmp_tests/src"
BUILD_PATH="${PREFIX}/hpxmp_tests/build_${BUILD_TYPE}_omp"
INSTALL_PATH="${PREFIX}/hpxmp_tests/install_${BUILD_TYPE}_omp"


# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_PATH}" "${INSTALL_PATH}"
fi

# Run CMake configuration
cmake \
  -G "Ninja" \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_CXX_STANDARD=17 \
  -DOpenMP_ROOT="${OMP_INSTALL_PATH}" \
  -Wdev -S "${SOURCE_PATH}" -B "${BUILD_PATH}"

# Build
cmake --build "${BUILD_PATH}" --target examples tests
