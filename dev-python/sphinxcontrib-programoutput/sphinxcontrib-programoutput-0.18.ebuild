# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Extension to sphinx to include program output"
HOMEPAGE="
	https://github.com/OpenNTI/sphinxcontrib-programoutput/
	https://pypi.org/project/sphinxcontrib-programoutput/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/furo

src_prepare() {
	distutils-r1_src_prepare

	# namespace
	rm src/sphinxcontrib/__init__.py || die
}

python_test() {
	epytest --pyargs sphinxcontrib.programoutput.tests
}
