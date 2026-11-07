# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_VERIFY_REPO=https://github.com/scikit-build/cython-cmake

inherit pypi

DESCRIPTION="CMake helpers for building Cython modules"
HOMEPAGE="
	https://github.com/scikit-build/cython-cmake/
	https://pypi.org/project/cython-cmake/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Upstream package is technically a Python package, but there's really
# no point in the Python wrapper and per-Python version duplicate files.

src_install() {
	insinto /usr/share/cmake/Modules
	doins src/cython_cmake/cmake/*.cmake
}
