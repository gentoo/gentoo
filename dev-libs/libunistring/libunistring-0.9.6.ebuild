# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Library for manipulating Unicode strings and C strings according to the Unicode standard"
HOMEPAGE="https://www.gnu.org/software/libunistring/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-3 GPL-3"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux"
IUSE="doc static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-nodocs.patch
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	dodoc AUTHORS README ChangeLog || die "dodoc failed"
	if use doc; then
		dohtml doc/*.html || die "dohtml failed"
		doinfo doc/*.info || die "doinfo failed"
	fi

	emake DESTDIR="${D}" install || die "Install failed"

	prune_libtool_files
}
