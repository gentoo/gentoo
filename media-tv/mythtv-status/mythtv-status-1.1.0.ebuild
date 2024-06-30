# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Displays the current status of MythTV at the command prompt"
HOMEPAGE="http://www.etc.gen.nz/projects/mythtv/mythtv-status.html"
SRC_URI="http://www.etc.gen.nz/projects/mythtv/tarballs/${P}.tar.gz"
#SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/libwww-perl
	dev-perl/XML-LibXML
	dev-perl/Date-Manip
	dev-perl/MIME-tools
	dev-perl/Sys-SigAction
	dev-perl/Config-Auto
	media-tv/mythtv[perl]"

src_compile() { :; }

src_install() {
	dobin bin/${PN}
	newman "${FILESDIR}"/${PN}-1.0.1.man ${PN}.1
	dodoc README FAQ ChangeLog THANKS
}

src_test() {
	emake test
}
