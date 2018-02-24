# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Terminal progress bar and status output for command line"
HOMEPAGE="http://liw.fi/ttystatus/"
SRC_URI="http://git.liw.fi/cgi-bin/cgit/cgit.cgi/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

python_test() {
	"${EPYTHON}" -m unittest discover -v -p '*_tests.py' || die
}
