# PyDSR - Python Bindings for DSR

PyDSR provides Python bindings for the DSR (Distributed Scene Representation) library, part of the Robocomp framework.

## Installation

### From wheel

```bash
pip install pydsr-*.whl
```

### From source

```bash
# Build the project with CMake
mkdir build && cd build
cmake ..
make -j$(nproc)

# Install the generated wheel
pip install python-wrapper/dist/pydsr-*.whl
```

## Usage

```python
import pydsr

# Your DSR code here
```

## Requirements

- Python >= 3.8
- Qt5 Core
- Eigen3
- pybind11

## License

This project is licensed under the GNU Lesser General Public License v3.0 - see the LICENSE file for details.