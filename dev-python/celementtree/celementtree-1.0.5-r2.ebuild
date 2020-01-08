# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="cElementTree-${PV}-20051216"

DESCRIPTION="The cElementTree module is a C implementation of the ElementTree API"
HOMEPAGE="http://effbot.org/zone/celementtree.htm https://pypi.org/project/cElementTree/"
SRC_URI="http://effbot.org/downloads/${MY_P}.tar.gz"

LICENSE="ElementTree"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="examples"

RDEPEND=">=dev-python/elementtree-1.2[${PYTHON_USEDEP}]
	>=dev-libs/expat-1.95.8"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}-use_system_expat.patch"
		"${FILESDIR}/${P}-setuptools.patch"
	)
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" selftest.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( samples/. selftest.py )

	distutils-r1_python_install_all
}
