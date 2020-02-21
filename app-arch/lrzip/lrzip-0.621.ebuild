# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Long Range ZIP or Lzma RZIP optimized for compressing large files"
HOMEPAGE="http://ck.kolivas.org/apps/lrzip/README.md"
SRC_URI="http://ck.kolivas.org/apps/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-libs/lzo
	 app-arch/bzip2
	 sys-libs/zlib"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	virtual/perl-Pod-Parser"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-missing-stdarg_h.patch
}

src_configure() {
	econf --docdir="/usr/share/doc/${P}"
}

src_install() {
	default
	rm "${D}/usr/share/doc/${P}/COPYING"
}
