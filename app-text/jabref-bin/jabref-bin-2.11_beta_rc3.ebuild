# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/jabref-bin/jabref-bin-2.11_beta_rc3.ebuild,v 1.1 2015/06/25 12:09:52 nicolasbock Exp $

EAPI=5

inherit eutils java-pkg-2

MY_PV_1="${PV/_beta/b}"
MY_PV="${MY_PV_1/_rc/}"
MY_URI_PV_1="${PV/rc/}"
MY_URI_PV="${MY_URI_PV_1//_/%20}"

DESCRIPTION="Java GUI for managing BibTeX and other bibliographies"
HOMEPAGE="http://jabref.sourceforge.net/"
SRC_URI="mirror://sourceforge/jabref/JabRef-${MY_PV}.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

src_unpack() {
	cp -v "${DISTDIR}/${A}" . || die
}

src_install() {
	java-pkg_newjar JabRef-${MY_PV}.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar
}
