# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="library providing an API for commonly used low-level network functions"
HOMEPAGE="http://libnet-dev.sourceforge.net/ https://github.com/libnet/libnet"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD BSD-2 HPND"
SLOT="1.1"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs"

DOCS=(
	ChangeLog.md README.md doc/MIGRATION.md
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
