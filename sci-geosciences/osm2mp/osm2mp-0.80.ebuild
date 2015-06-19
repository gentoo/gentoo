# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/osm2mp/osm2mp-0.80.ebuild,v 1.4 2011/06/04 07:56:26 scarabeus Exp $

EAPI=4

DESCRIPTION="Converts openstreetmap data to mp format (used e. g. by mkgmap)"
HOMEPAGE="http://forum.openstreetmap.org/viewtopic.php?id=1162"
SRC_URI="http://garminmapsearch.com/osm/${PN}_v${PV/./}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Template-Toolkit
	virtual/perl-Getopt-Long"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	sed -i \
		-e 's:poi.cfg:/usr/share/osm2mp/poi.cfg:g' \
		-e 's:poly.cfg:/usr/share/osm2mp/poly.cfg:g' \
		-e 's:header.tpl:/usr/share/osm2mp/header.tpl:g' \
		osm2mp.pl || die "sed failed"
}

src_install() {
	newbin osm2mp.pl osm2mp
	insinto /usr/share/osm2mp
	doins poi.cfg poly.cfg header.tpl
	dodoc todo
}
