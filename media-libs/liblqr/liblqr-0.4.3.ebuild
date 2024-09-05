# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Easy to use C/C++ seam carving library"
HOMEPAGE="
	https://liblqr.wikidot.com/
	https://github.com/carlobaldassi/liblqr
"
# NOTE: github also offers tarballs but wikidot uses bz2
SRC_URI="https://liblqr.wikidot.com/local--files/en:download-page/${PN}-1-${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-1-${PV}"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="3.2.3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="dev-libs/glib:2"
DEPEND=${RDEPEND}
BDEPEND="virtual/pkgconfig"

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
