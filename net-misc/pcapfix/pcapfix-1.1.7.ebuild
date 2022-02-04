# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Repair and fix broken pcap files"
HOMEPAGE="https://f00l.de/pcapfix/"
SRC_URI="https://f00l.de/pcapfix/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-1.1.7-musl-stdint.patch.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=( Changelog README )

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.7-respect-CFLAGS.patch
	"${WORKDIR}"/${PN}-1.1.7-musl-stdint.patch
)

src_prepare() {
	default

	use debug || sed -e 's/DEBUGFLAGS = -g/DEBUGFLAGS =/g' -i Makefile || die
}

src_configure() {
	tc-export CC

	append-lfs-flags
}

src_install() {
	doman pcapfix.1
	dobin pcapfix
	einstalldocs
}
