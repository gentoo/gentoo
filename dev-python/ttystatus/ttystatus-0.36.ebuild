# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="Terminal progress bar and status output for command line"
HOMEPAGE="https://liw.fi/ttystatus/"
SRC_URI="http://git.liw.fi/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

python_test() {
	"${EPYTHON}" -m unittest discover -v -p '*_tests.py' || die
}
