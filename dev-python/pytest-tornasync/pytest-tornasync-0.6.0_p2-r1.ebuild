# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

MY_P=${PN}-${PV/_p/.post}
DESCRIPTION="Pytest plugin for testing Python 3.5+ Tornado code"
HOMEPAGE="
	https://github.com/eukaryote/pytest-tornasync/
	https://pypi.org/project/pytest-tornasync/
"
SRC_URI="
	https://github.com/eukaryote/pytest-tornasync/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/pytest-3.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-5.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# Do not install the license file
	sed -i -e '/LICENSE/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_tornasync.plugin
}
