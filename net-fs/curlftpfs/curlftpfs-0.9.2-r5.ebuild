# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="File system for accessing ftp hosts based on FUSE"
HOMEPAGE="https://curlftpfs.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
RESTRICT="test" # bug 258460

RDEPEND="
	>=net-misc/curl-7.17.0
	>=sys-fs/fuse-2.2:0=
	>=dev-libs/glib-2.0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-64bit_filesize.patch
	"${FILESDIR}"/${PN}-0.9.2-darwin.patch
	"${FILESDIR}"/${PN}-0.9.2-memleak.patch
	"${FILESDIR}"/${PN}-0.9.2-memleak-nocache.patch
	"${FILESDIR}"/${PN}-0.9.2-fix-escaping.patch
	"${FILESDIR}"/${PN}-0.9.2-__off_t.patch
)

src_prepare() {
	default

	# automake-1.13.1 obsoletes AM_* bit #469818
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/861299
	# https://sourceforge.net/p/curlftpfs/bugs/76/
	filter-lto

	default
}

src_install() {
	default
	dodoc README
}
