# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="${PN}_${PV}"

DESCRIPTION="A simple podcast aggregator written in bash"
HOMEPAGE="http://podget.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	# There is a Makefile that we don't use
	:
}

src_install() {
	dobin podget
	doman DOC/podget.7
	dodoc -r Changelog README SCRIPTS/
}
