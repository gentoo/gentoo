# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop multilib toolchain-funcs

DESCRIPTION="Small dynamic tiling window manager for X11"
HOMEPAGE="https://github.com/conformal/spectrwm"
SRC_URI="https://github.com/conformal/spectrwm/archive/${PN^^}_${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!x11-wm/scrotwm
	x11-misc/dmenu
"
DEPEND="
	elibc_musl? ( sys-libs/queue-standalone )
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXt
	x11-libs/xcb-util
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.4.0-gentoo.patch
)
S=${WORKDIR}/${PN}-${PN^^}_${PV//./_}

src_prepare() {
	sed -i -e '/LICENSE.md/d' linux/Makefile || die
	default
}

src_compile() {
	tc-export CC PKG_CONFIG
	emake -C linux PREFIX="${EROOT}/usr" LIBDIR="${EROOT}/usr/$(get_libdir)"
}

src_install() {
	emake -C linux PREFIX="${EROOT}/usr" LIBDIR="${EROOT}/usr/$(get_libdir)" \
		SYSCONFDIR="${EROOT}/etc" DOCDIR="${EROOT}/usr/share/doc/${P}" \
		DESTDIR="${D}" install

	dodoc README.md ${PN}_*.conf {initscreen,screenshot}.sh
}
