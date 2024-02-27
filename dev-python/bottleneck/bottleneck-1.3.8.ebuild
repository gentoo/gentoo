# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Fast NumPy array functions written in C"
HOMEPAGE="
	https://github.com/pydata/bottleneck/
	https://pypi.org/project/Bottleneck/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/numpy-1.9.1[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

distutils_enable_tests pytest

src_prepare() {
	# don't overwrites user's optimization level
	sed -e '/extra_compile_args=\["-O2"\]/d' -i setup.py || die

	distutils-r1_src_prepare
}

python_test() {
	rm -rf bottleneck || die
	epytest --pyargs bottleneck
}
