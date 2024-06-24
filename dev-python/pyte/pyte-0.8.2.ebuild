# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Simple VTXXX-compatible terminal emulator"
HOMEPAGE="
	https://pypi.org/project/pyte/
	https://github.com/selectel/pyte/
"
SRC_URI="
	https://github.com/selectel/pyte/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/wcwidth[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# run pytest directly for tests
	sed -i '/setup_requires/d' setup.py || die
	distutils-r1_python_prepare_all
}
