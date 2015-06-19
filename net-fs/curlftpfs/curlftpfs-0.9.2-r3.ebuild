# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/curlftpfs/curlftpfs-0.9.2-r3.ebuild,v 1.4 2014/01/14 13:56:02 ago Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="File system for accessing ftp hosts based on FUSE"
HOMEPAGE="http://curlftpfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
RESTRICT="test" # bug 258460

RDEPEND=">=net-misc/curl-7.17.0
	>=sys-fs/fuse-2.2
	>=dev-libs/glib-2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-64bit_filesize.patch
	epatch "${FILESDIR}"/${PN}-0.9.2-darwin.patch
	epatch "${FILESDIR}"/${PN}-0.9.2-memleak.patch
	epatch "${FILESDIR}"/${PN}-0.9.2-memleak-nocache.patch
	epatch "${FILESDIR}"/${PN}-0.9.2-fix-escaping.patch

	# automake-1.13.1 obsoletes AM_* bit #469818
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die

	epatch_user

	eautoreconf
}

src_install() {
	default
	dodoc README
}
