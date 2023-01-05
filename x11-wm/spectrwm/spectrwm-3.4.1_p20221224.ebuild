# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
COMMIT=67e16a136e505832bcd6322c02de28a8adc0af93
inherit toolchain-funcs

DESCRIPTION="Small dynamic tiling window manager for X11"
HOMEPAGE="https://github.com/conformal/spectrwm"
SRC_URI="https://github.com/conformal/spectrwm/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-misc/dmenu
"
DEPEND="
	elibc_musl? ( sys-libs/queue-standalone )
	virtual/pkgconfig
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXt
	x11-libs/xcb-util
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
"
PATCHES=(
	"${FILESDIR}"/${P}-fix-cflags-ldflags.patch
)
S=${WORKDIR}/${PN}-${COMMIT}

src_prepare() {
	sed -i -e '/LICENSE.md/d' linux/Makefile || die
	default
}

src_compile() {
	tc-export CC PKG_CONFIG
	emake -C linux PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake -C linux PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		SYSCONFDIR="${EPREFIX}/etc" DOCDIR="${EPREFIX}/usr/share/doc/${P}" \
		DESTDIR="${D}" install

	dodoc README.md ${PN}_*.conf {initscreen,screenshot}.sh
}
