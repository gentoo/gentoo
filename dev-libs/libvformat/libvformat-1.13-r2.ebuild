# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

DESCRIPTION="Library to read and write vcard files"
HOMEPAGE="https://sourceforge.net/projects/vformat/"
SRC_URI="
	mirror://debian/pool/main/libv/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/libv/${PN}/${PN}_${PV}-10.debian.tar.gz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="static-libs"

S="${WORKDIR}/${P}.orig"

src_prepare() {
	epatch \
		"${WORKDIR}"/debian/patches/*.patch \
		"${FILESDIR}"/${PN}-nodoc.patch \
		"${FILESDIR}"/${P}-has_unistd.patch \
		"${FILESDIR}"/${P}-str.patch

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files
}
