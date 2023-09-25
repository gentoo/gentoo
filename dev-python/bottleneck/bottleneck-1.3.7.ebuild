# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Fast NumPy array functions written in C"
HOMEPAGE="
	https://github.com/pydata/bottleneck/
	https://pypi.org/project/Bottleneck/
"
SRC_URI="
	$(pypi_sdist_url --no-normalize Bottleneck)
"
S=${WORKDIR}/${P^}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

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
