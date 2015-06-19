# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/springgraph/springgraph-88.ebuild,v 1.9 2011/02/06 07:45:39 leio Exp $

inherit eutils

DESCRIPTION="Generate spring graphs from graphviz input files"
HOMEPAGE="http://www.chaosreigns.com/code/springgraph"
MY_PV="0.${PV}"
MY_P="${PN}_${MY_PV}"
SRC_FILE="${MY_P}.orig.tar.gz"
SRC_DEBIAN_PATCH="${PN}_0.82-5.diff.gz"
SRC_URI="http://www.chaosreigns.com/code/springgraph/dl/${PN}.pl.${PV}
		 mirror://debian/pool/main/${PN:0:1}/${PN}/${SRC_DEBIAN_PATCH}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ~ppc64 sparc x86"
IUSE=""
DEPEND=""
RDEPEND="dev-perl/GD"
S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	mkdir -p ${S}
	cp ${DISTDIR}/${PN}.pl.${PV} ${S}/${PN}
	EPATCH_OPTS="-p1 -d ${S}" epatch ${DISTDIR}/${SRC_DEBIAN_PATCH}
}

src_compile() {
	# nothing to do
	:
}

src_install() {
	into /usr
	dobin ${PN}
	doman debian/${PN}.1
}
