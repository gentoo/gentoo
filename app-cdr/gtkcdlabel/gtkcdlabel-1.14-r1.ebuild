# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="a GUI frontend to cdlabelgen which is a program that can generate a variety of CD tray covers"
HOMEPAGE="http://gtkcdlabel.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	>=app-cdr/cdlabelgen-4
	dev-python/pygtk[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}

src_prepare() {
	python_fix_shebang .
}

src_install() {
	dobin usr/bin/${PN}.py || die "dobin failed"
	insinto /usr/share
	doins -r usr/share/{applications,${PN},pixmaps} || die "doins failed"
	dodoc usr/share/doc/${PN}/{AUTHORS,README}
}
