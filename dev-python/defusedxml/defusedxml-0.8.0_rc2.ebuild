# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

MY_P=${P/_/}
DESCRIPTION="XML bomb protection for Python stdlib modules, an xml serialiser"
HOMEPAGE="
	https://github.com/tiran/defusedxml/
	https://pypi.org/project/defusedxml/
"
SRC_URI="
	https://github.com/tiran/defusedxml/archive/v${PV/_/}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e 's:verbosity=1:verbosity=2:' tests.py || die
	mv other examples || die
}

python_test() {
	"${EPYTHON}" tests.py -v || die
}

python_install_all() {
	use examples && dodoc -r examples/
	distutils-r1_python_install_all
}
