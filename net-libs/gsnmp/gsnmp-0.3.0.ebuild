# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="An SNMP library based on glib and gnet"
HOMEPAGE="https://github.com/schoenw/gsnmp"
SRC_URI="ftp://ftp.ibr.cs.tu-bs.de/pub/local/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux"
IUSE="static-libs"

DEPEND="
	dev-libs/glib:2
	net-libs/gnet
"
RDEPEND="${DEPEND}"

DOCS="README"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-g_access.patch \
		"${FILESDIR}"/${P}-pkg_config.patch \
		"${FILESDIR}"/${P}-underquoting.patch

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files
}
