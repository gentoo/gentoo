# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop multilib toolchain-funcs

DESCRIPTION="Small dynamic tiling window manager for X11"
HOMEPAGE="https://github.com/conformal/spectrwm"
SRC_URI="${HOMEPAGE}/archive/${PN^^}_${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!x11-wm/scrotwm
	x11-misc/dmenu
"
DEPEND="
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/xcb-util
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.2.0-gentoo.patch
)
S=${WORKDIR}/${PN}-${PN^^}_${PV//./_}

src_compile() {
	tc-export CC PKG_CONFIG
	emake -C linux PREFIX="${EROOT}/usr" LIBDIR="${EROOT}/usr/$(get_libdir)"
}

src_install() {
	emake -C linux PREFIX="${EROOT}/usr" LIBDIR="${EROOT}/usr/$(get_libdir)" \
		DESTDIR="${D}" install

	insinto /etc
	doins ${PN}.conf
	dodoc CHANGELOG.md README.md ${PN}_*.conf {initscreen,screenshot}.sh

	make_session_desktop ${PN} ${PN}
}
