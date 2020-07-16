# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="OpenBSD fork of calmwm, a clean and lightweight window manager"
HOMEPAGE="https://www.openbsd.org/cgi-bin/cvsweb/xenocara/app/cwm/
	https://github.com/chneukirchen/cwm"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/leahneukirchen/${PN}.git"
	KEYWORDS="amd64 arm x86"
else
	SRC_URI="https://github.com/leahneukirchen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm ~arm64 x86"
fi

LICENSE="ISC"
SLOT="0"

RDEPEND="x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/bison
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-Makefile.patch"
)

src_compile() {
	emake CFLAGS="${CFLAGS} -D_GNU_SOURCE" CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc README
	make_session_desktop ${PN} ${PN}
}
