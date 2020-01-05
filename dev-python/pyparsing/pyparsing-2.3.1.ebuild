# Copyright 2004-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

MY_P=${P/-/_}
DESCRIPTION="Easy-to-use Python module for text parsing"
HOMEPAGE="https://github.com/pyparsing/pyparsing https://pypi.org/project/pyparsing/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_P}.tar.gz"
# pypi releases and generated github tarballs lack tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"

# setuptools currently vendors its own copy of pyparsing to avoid bootstrapping
# issues so depend on it here for consistency
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S=${WORKDIR}/${PN}-${MY_P}

python_test() {
	"${PYTHON}" unitTests.py || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
