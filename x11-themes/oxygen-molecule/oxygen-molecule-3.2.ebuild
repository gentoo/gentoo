# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_PN=Oxygen-Molecule

DESCRIPTION="Unified KDE and GTK+ theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=103741"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/103741-${MY_PN}_${PV}_theme.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="kde-frameworks/oxygen-icons"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	tar -xzf kde44-${PN}.tar.gz || die
}

src_install() {
	insinto /usr/share/themes
	doins -r kde44-${PN} || die
	insinto /usr/share/${PN}
	doins *.colors || die
	insinto /usr/share/doc/${PF}/pdf
	doins *.pdf || die
	insinto /usr/share/doc/${PF}/odt
	doins *.odt || die
}
