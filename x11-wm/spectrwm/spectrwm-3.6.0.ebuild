# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Small dynamic tiling window manager for X11"
HOMEPAGE="https://github.com/conformal/spectrwm"
SRC_URI="https://github.com/conformal/spectrwm/archive/${PN^^}_${PV//./_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PN^^}_${PV//./_}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	elibc_musl? ( sys-libs/queue-standalone )
	dev-libs/libbsd
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXft
	x11-libs/libXrandr
	x11-libs/libXt
	x11-libs/xcb-util
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
"
RDEPEND="
	${DEPEND}
	x11-misc/dmenu
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/spectrwm-3.6.0-fix-cflags-ldflags.patch
)

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
