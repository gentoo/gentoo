# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Accelerator for ws4py, autobahn and tornado"
HOMEPAGE="
	https://github.com/methane/wsaccel/
	https://pypi.org/project/wsaccel/
"
SRC_URI="
	https://github.com/methane/wsaccel/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv ~sparc x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	cd tests || die
	epytest
}
