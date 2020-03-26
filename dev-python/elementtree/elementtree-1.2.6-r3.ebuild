# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="${P}-20050316"

DESCRIPTION="A light-weight XML object model for Python"
HOMEPAGE="http://effbot.org/zone/element-index.htm https://pypi.org/project/elementtree/"
SRC_URI="http://effbot.org/downloads/${MY_P}.tar.gz"

LICENSE="ElementTree"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed -e "s/distutils.core/setuptools/" -i setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" selftest.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
