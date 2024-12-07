# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Extension to sphinx to include program output"
HOMEPAGE="
	https://github.com/OpenNTI/sphinxcontrib-programoutput/
	https://pypi.org/project/sphinxcontrib-programoutput/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs

src_prepare() {
	distutils-r1_src_prepare

	# namespace
	rm src/sphinxcontrib/__init__.py || die
}

python_test() {
	epytest --pyargs sphinxcontrib.programoutput.tests
}
