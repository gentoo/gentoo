# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 multilib

XPAPV=2.1.15

DESCRIPTION="Python interface to XPA to communicate with DS9"
HOMEPAGE="http://hea-www.harvard.edu/RD/ds9/pyds9/"
SRC_URI="http://hea-www.harvard.edu/RD/download/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=x11-libs/xpa-${XPAPV}"
RDEPEND="${DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/astropy[${PYTHON_USEDEP}]"

DOCS=(changelog README)

src_prepare() {
	rm -r xpa-${XPAPV} || die
	sed -i \
		-e "/py_modules/s|\],|\])|" \
		-e '/data_files/,$ d' \
		setup.py || die
	sed -i \
		-e "s|./xpa-${XPAPV}|${EROOT%/}/usr/$(get_libdir)|" \
		xpa.py || die
	sed -i \
		-e "s|sys.path|['${EROOT%/}/usr/bin']|" \
		ds9.py || die
	distutils-r1_src_prepare
}
