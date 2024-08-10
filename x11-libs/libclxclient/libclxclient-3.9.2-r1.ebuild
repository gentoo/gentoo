# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="C++ wrapper library around the X Window System API"
HOMEPAGE="https://kokkinizita.linuxaudio.org/linuxaudio/index.html"
SRC_URI="https://kokkinizita.linuxaudio.org/linuxaudio/downloads/clxclient-${PV}.tar.bz2"
S="${WORKDIR}/clxclient-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

CDEPEND="
	dev-libs/libclthreads
	media-libs/freetype:2
	x11-libs/libX11
	x11-libs/libXft
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS )

PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
	"${FILESDIR}/${P}-enumip-include-fix.patch"
)

src_compile() {
	tc-export CXX
	local prefix="${EPREFIX}/usr"
	cd "${S}/source"
	emake INCDIR="${prefix}/include" LIBDIR="${prefix}/$(get_libdir)" PKGCONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	default

	local prefix="${ED}/usr"
	cd "${S}/source"
	emake INCDIR="${prefix}/include" LIBDIR="${prefix}/$(get_libdir)" PKGCONFIG="$(tc-getPKG_CONFIG)" install
}
