# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Displays the current status of MythTV at the command prompt"
HOMEPAGE="http://www.etc.gen.nz/projects/mythtv/mythtv-status.html"
SRC_URI="http://www.etc.gen.nz/projects/mythtv/tarballs/${P}.tar.gz"
#SRC_URI="mirror://ubuntu/pool/universe/m/mythtv-status/mythtv-status_0.10.2.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-perl/libwww-perl
	dev-perl/XML-LibXML
	dev-perl/Date-Manip
	dev-perl/MIME-tools
	dev-perl/Sys-SigAction
	dev-perl/Config-Auto
	media-tv/mythtv[perl]"
RDEPEND="${DEPEND}"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dobin bin/mythtv-status
	doman "${FILESDIR}/mythtv-status.1"
	dodoc README FAQ ChangeLog THANKS
}
