# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit versionator eutils autotools

DESCRIPTION="Archiver that creates standard zips to create identical files over multiple systems"
HOMEPAGE="https://sourceforge.net/projects/trrntzip"

MY_PN=trrntzip
MY_PV="$(replace_version_separator 1 '')"
MY_P=${MY_PN}_v${MY_PV}
S="${WORKDIR}"/${MY_PN}

SRC_URI="mirror://sourceforge/trrntzip/${MY_P}_src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sys-libs/zlib"
RDEPEND=""

S=${WORKDIR}/trrntzip

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/fix-perms.patch

	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
}
