# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A tool for monitoring webpages for updates"
HOMEPAGE="http://thp.io/2008/urlwatch/ http://pypi.python.org/pypi/urlwatch"
SRC_URI="http://thp.io/2008/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/python-futures[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	|| ( www-client/lynx app-text/html2text )"

python_prepare() {
	if [[ ${EPYTHON} == python3.* ]]; then
		2to3 -nw --no-diffs urlwatch lib/urlwatch/*.py \
			share/urlwatch/examples/hooks.py.example setup.py || die
	fi
}
