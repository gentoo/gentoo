# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="
	https://github.com/Pylons/pastedeploy/
	https://pypi.org/project/PasteDeploy/
"
SRC_URI="
	https://github.com/Pylons/pastedeploy/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

RDEPEND="
	!dev-python/namespace-paste
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov::' pytest.ini || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}
