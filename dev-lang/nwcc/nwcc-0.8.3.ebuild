# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="${PN}_${PV}"

DESCRIPTION="Nils Weller's C Compiler"
HOMEPAGE="http://nwcc.sourceforge.net/index.html"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/nwcc%200.8.3/${MY_P}.tar.gz"
SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# custom hackery hack
	ABI="" ./configure --installprefix=/usr || die
}
