# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Minimal console text editor"
HOMEPAGE="https://github.com/atsb/dav-text"
SRC_URI="https://github.com/atsb/dav-text/archive/refs/tags/dav-text-${PV}.tar.gz"
S="${WORKDIR}/dav-text-dav-text-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~riscv x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.8.5-fno-common.patch )

DOCS=( README.md )

src_prepare() {
	unpack ./dav.1.gz
	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS} $( $(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin dav
	doman dav.1
	einstalldocs
}
