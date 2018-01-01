# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="Framework for Unix-like command line programs"
HOMEPAGE="http://liw.fi/cliapp/"
SRC_URI="http://git.liw.fi/cgi-bin/cgit/cgit.cgi/cliapp/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

# test deps not supporting python 3
RESTRICT="test"

MY_DEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	"

DEPEND="${PYTHON_DEPS}
	${MY_DEPEND}"
#	test? ( >=dev-python/CoverageTestRunner-1.11 dev-python/pep8 )
#	"

RDEPEND="
	${MY_DEPEND}
	"

src_test() {
	addwrite /proc/self/comm
	distutils-r1_src_test
}

python_test() {
	${PYTHON} -m CoverageTestRunner --ignore-missing-from=without-tests || die
}
