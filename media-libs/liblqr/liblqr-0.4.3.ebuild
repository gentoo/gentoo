# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Easy to use C/C++ seam carving library"
HOMEPAGE="http://liblqr.wikidot.com/ https://github.com/carlobaldassi/liblqr"
SRC_URI="https://liblqr.wikidot.com/local--files/en:download-page/${PN}-1-${PV}.tar.bz2"
S="${WORKDIR}/${PN}-1-${PV}"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv x86"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# bug #943824
	append-cflags -std=gnu17

	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
