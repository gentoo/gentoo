# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="A drop-in replacement for smbus-cffi/smbus-python in pure Python"
HOMEPAGE="
	https://pypi.org/project/smbus2/
	https://github.com/kplindegaard/smbus2/
"
SRC_URI="
	https://github.com/kplindegaard/smbus2/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest -s
}
