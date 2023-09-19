# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="OpenBSD fork of calmwm, a clean and lightweight window manager"
HOMEPAGE="https://github.com/leahneukirchen/cwm
	https://www.openbsd.org/cgi-bin/cvsweb/xenocara/app/cwm/
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/leahneukirchen/cwm.git"
else
	SRC_URI="https://github.com/leahneukirchen/cwm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm ~arm64 ~riscv x86"
fi

LICENSE="ISC"
SLOT="0"

DEPEND="x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXrandr
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	virtual/pkgconfig
"

src_compile() {
	emake CFLAGS="${CFLAGS} -D_GNU_SOURCE" CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc README
	make_session_desktop ${PN} ${PN}
}
