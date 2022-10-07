# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_P="PyHamcrest-${PV}"
DESCRIPTION="Hamcrest framework for matcher objects"
HOMEPAGE="
	https://github.com/hamcrest/PyHamcrest/
	https://pypi.org/project/PyHamcrest/
"
SRC_URI="
	https://github.com/hamcrest/PyHamcrest/archive/V${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
