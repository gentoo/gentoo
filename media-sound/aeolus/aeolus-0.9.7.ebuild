# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic multilib desktop xdg

DESCRIPTION="A synthesised pipe organ emulator"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
CDEPEND="
	dev-libs/libclthreads
	media-libs/alsa-lib
	>=media-libs/zita-alsa-pcmi-0.3
	sys-libs/readline:0
	virtual/jack
	x11-libs/libclxclient
	x11-libs/libX11
	x11-libs/libXft
"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	media-libs/stops
"

DOCS=( README COPYING AUTHORS )

PATCHES=(
	"${FILESDIR}"/${P}-fix-Makefile.patch
)

src_compile() {
	cd "${S}"/source || die "Failed to cd to source dir"
	tc-export CXX
	append-cppflags $($(tc-getPKG_CONFIG) --cflags xft)
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EXPREFIX}/usr/$(get_libdir)"
}

src_install() {
	default

	cd "${S}"/source || die "Failed to cd to source dir"
	emake PREFIX="${D}/usr" install
	echo "-S ${EPREFIX}/usr/share/stops" > "${T}/aeolus.conf"
	insinto /etc
	doins "${T}/aeolus.conf"

	make_desktop_entry aeolus Aeolus "" "AudioVideo"
}
