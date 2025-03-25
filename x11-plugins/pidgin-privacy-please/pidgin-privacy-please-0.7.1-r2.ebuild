# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Pidgin plugin to stop spammers from annoying you"
HOMEPAGE="https://code.google.com/p/pidgin-privacy-please/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="<net-im/pidgin-3[gui]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.1-include-path.patch
)

src_prepare() {
	default
	sed -e 's: -Wall -g3::' -i configure.ac || die
	eautoreconf
}

src_install() {
	default

	find "${D}" -type f -name '*.la' -delete || die "la removal failed"
}
