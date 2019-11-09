# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="0.${PV}"
MY_P="${PN}_${MY_PV}"
SRC_FILE="${MY_P}.orig.tar.gz"
SRC_DEBIAN_PATCH="${PN}_0.82-5.diff.gz"

DESCRIPTION="Generate spring graphs from graphviz input files"
HOMEPAGE="http://www.chaosreigns.com/code/springgraph"
SRC_URI="http://www.chaosreigns.com/code/springgraph/dl/${PN}.pl.${PV}
	mirror://debian/pool/main/${PN:0:1}/${PN}/${SRC_DEBIAN_PATCH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/GD"

S=${WORKDIR}

PATCHES=( "${SRC_DEBIAN_PATCH%.gz}" )

src_unpack() {
	cp "${DISTDIR}"/${PN}.pl.${PV} ${PN} || die
	default
}

src_install() {
	dobin ${PN}
	doman debian/${PN}.1
}
