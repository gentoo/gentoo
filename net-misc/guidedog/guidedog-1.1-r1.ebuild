# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 kde4-base

DESCRIPTION="A network/routing configuration utility for KDE 4"
HOMEPAGE="http://www.simonzone.com/software/guidedog/"
SRC_URI="http://www.simonzone.com/software/guidedog/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

DEPEND="
	${PYTHON_DEPS}
	dev-python/PyQt4[${PYTHON_USEDEP}]
	$(add_kdebase_dep pykde4 "${PYTHON_USEDEP}")
"
RDEPEND="${DEPEND}
	net-firewall/iptables
"

DOCS=( AUTHORS ChangeLog README TODO )

pkg_setup() {
	python-single-r1_pkg_setup
	kde4-base_pkg_setup
}

src_prepare() {
	sed -e 's/python2.5/python/' -i src/sealed.py || die
	python_fix_shebang src

	kde4-base_src_prepare
}

src_install() {
	kde4-base_src_install
	rm -f "${ED}"usr/share/apps/guidedog/*.pyc
}
