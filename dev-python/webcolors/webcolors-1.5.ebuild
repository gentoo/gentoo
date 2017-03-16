# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Color names and value formats defined by the HTML and CSS specifications"
HOMEPAGE="https://pypi.python.org/pypi/webcolors https://github.com/ubernostrum/webcolors"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	"

python_test() {
	nosetests --verbose || die
}
