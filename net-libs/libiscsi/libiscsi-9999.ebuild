# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="iscsi client library and utilities"
HOMEPAGE="https://github.com/sahlberg/libiscsi"
SRC_URI=""
EGIT_REPO_URI="https://github.com/sahlberg/${PN}.git"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="dev-libs/libgcrypt:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-manpages \
		--disable-werror \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
