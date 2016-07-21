# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils git-r3

DESCRIPTION="iscsi client library and utilities"
HOMEPAGE="https://github.com/sahlberg/libiscsi"
SRC_URI=""
EGIT_REPO_URI="git://github.com/sahlberg/libiscsi.git"

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
	prune_libtool_files
}
