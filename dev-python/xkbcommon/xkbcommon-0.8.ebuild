# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1

DESCRIPTION="Python bindings for libxkbcommon using cffi"
HOMEPAGE="
	https://github.com/sde1000/python-xkbcommon
	https://pypi.org/project/xkbcommon/
"
SRC_URI="
	https://github.com/sde1000/python-xkbcommon/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}"/python-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

# x11-libs/libxkbcommon dep per README
RDEPEND="
	>=x11-libs/libxkbcommon-${PV}
	virtual/python-cffi[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_test() {
	# No die deliberately as sometimes it doesn't exist
	rm -r xkbcommon

	epytest
}
