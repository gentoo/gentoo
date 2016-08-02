# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils qmake-utils

MY_PN=${PN/qc/QC}

DESCRIPTION="Qt4 based checkers game"
HOMEPAGE="https://code.google.com/p/qcheckers/"
SRC_URI="https://qcheckers.googlecode.com/files/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_PN}

src_configure() {
	eqmake4 ${MY_PN}.pro
}

src_install() {
	dobin ${MY_PN}
	newicon icons/help-about.png ${PN}.png
	make_desktop_entry ${MY_PN} ${MY_PN}
	dodoc README
}
