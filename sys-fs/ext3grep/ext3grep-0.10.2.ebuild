# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/ext3grep/ext3grep-0.10.2.ebuild,v 1.4 2012/11/03 10:03:44 ssuominen Exp $

EAPI=4
inherit eutils

DESCRIPTION="Recover deleted files on an ext3 file system"
HOMEPAGE="http://code.google.com/p/ext3grep/"
SRC_URI="http://ext3grep.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug pch"

DOCS="NEWS README"

RDEPEND=""
DEPEND="sys-fs/e2fsprogs
	virtual/os-headers
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.10.1-gcc44.patch \
		"${FILESDIR}"/${P}-include-unistd_h-for-sysconf.patch

	# Fix build against latest e2fsprogs, taken from
	# https://code.google.com/p/ext3grep/issues/detail?id=34
	epatch "${FILESDIR}"/${P}-new-e2fsprogs.diff
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable pch)
}
