# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="An SNMP library based on glib and gnet"
HOMEPAGE="http://cnds.eecs.jacobs-university.de/users/schoenw/articles/software/index.html"
SRC_URI="ftp://ftp.ibr.cs.tu-bs.de/pub/local/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~amd64-linux ~ppc x86"
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
