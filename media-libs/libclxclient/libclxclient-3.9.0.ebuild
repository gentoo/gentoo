# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs

MY_P=${P/lib/}

S="${WORKDIR}/${MY_P}"

DESCRIPTION="C++ wrapper library around the X Window System API"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="
	>=dev-libs/libclthreads-2.4.0
	media-libs/freetype:2
	x11-libs/libX11
	x11-libs/libXft
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_compile() {
	tc-export CC CXX
	emake PREFIX="${EPREFIX}/usr" LIBDIR="$(get_libdir)" PKGCONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake PREFIX="${ED}/usr" LIBDIR="$(get_libdir)" PKGCONFIG="$(tc-getPKG_CONFIG)" install
	dodoc AUTHORS
}
