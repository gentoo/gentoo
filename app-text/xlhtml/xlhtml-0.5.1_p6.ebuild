# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools vcs-clean

MY_PV=${PV/_p*/}
DEB_PR=${PV/*_p/}

DESCRIPTION="Convert MS Excel and Powerpoint files to HTML"
HOMEPAGE="http://chicago.sourceforge.net/xlhtml/ http://packages.debian.org/etch/xlhtml/"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}-${DEB_PR}.diff.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"

PATCHES=(
	"${WORKDIR}"/${PN}_${MY_PV}-${DEB_PR}.diff
	"${FILESDIR}"/${PN}-0.5.1_p6-respect-AR.patch
)

src_prepare() {
	default

	ecvs_clean

	mv configure.{in,ac} || die

	eautoreconf
}

src_install() {
	default

	docinto cole
	dodoc cole/{AUTHORS,COPYING,NEWS,ChangeLog,THANKS,TODO}

	docinto ppthtml
	dodoc ppthtml/{ChangeLog,README,THANKS}

	docinto xlhtml
	dodoc -r xlhtml/{ChangeLog,README,THANKS,TODO,contrib}
}
