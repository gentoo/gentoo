# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

MY_P="Paste-${PV}"
DESCRIPTION="Tools for using a Web Server Gateway Interface stack"
HOMEPAGE="https://pypi.org/project/Paste/"
SRC_URI="mirror://pypi/${MY_P::1}/${PN^}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris"

RDEPEND="
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs

EPYTEST_DESELECT=(
	# Internet
	tests/test_proxy.py
)

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}
