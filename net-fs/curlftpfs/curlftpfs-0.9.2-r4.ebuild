# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="File system for accessing ftp hosts based on FUSE"
HOMEPAGE="http://curlftpfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
RESTRICT="test" # bug 258460

RDEPEND=">=net-misc/curl-7.17.0
	>=sys-fs/fuse-2.2:0=
	>=dev-libs/glib-2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-64bit_filesize.patch
	"${FILESDIR}"/${PN}-0.9.2-darwin.patch
	"${FILESDIR}"/${PN}-0.9.2-memleak.patch
	"${FILESDIR}"/${PN}-0.9.2-memleak-nocache.patch
	"${FILESDIR}"/${PN}-0.9.2-fix-escaping.patch
)

src_prepare() {
	default

	# automake-1.13.1 obsoletes AM_* bit #469818
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die

	eautoreconf
}

src_install() {
	default
	dodoc README
}
