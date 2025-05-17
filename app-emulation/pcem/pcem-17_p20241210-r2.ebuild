# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="bd1283b91282d522617ac6d29eb0f271ded83ffc"
WX_GTK_VER="3.2-gtk3"

inherit cmake desktop flag-o-matic wxwidgets

DESCRIPTION="A PC emulator that specializes in running old operating systems and software"
HOMEPAGE="https://github.com/sarah-walker-pcem/pcem/"
SRC_URI="https://github.com/sarah-walker-pcem/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa experimental networking plugins wayland"

RDEPEND="
	media-libs/libsdl2
	media-libs/libglvnd
	media-libs/openal
	x11-libs/wxGTK:${WX_GTK_VER}=[tiff,X]
	alsa? ( media-libs/alsa-lib )
	experimental? ( media-libs/freetype )
	networking? ( net-libs/libpcap )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "README.md" "TESTED.md" )

src_prepare() {
	default
	cmake_src_prepare
}

src_configure() {
	setup-wxwidgets

	# Using RelWithDebInfo bypasses upstream's default (bug #948388)
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DFORCE_X11=$(usex !wayland)
		-DPCEM_LIB_DIR="$(get_libdir)"
		-DPLUGIN_ENGINE=$(usex plugins)
		-DUSE_ALSA=$(usex alsa)
		-DUSE_EXPERIMENTAL=$(usex experimental)
		$(usex experimental '-DUSE_EXPERIMENTAL_PGC=ON')
		$(usex experimental '-DUSE_EXPERIMENTAL_PRINTER=ON')
		-DUSE_NETWORKING=$(usex networking)
		$(usex networking '-DUSE_PCAP_NETWORKING=ON')
	)

	cmake_src_configure
}

src_install() {
	default
	cmake_src_install

	insinto /usr/share/pcem
	doins -r nvr

	newicon src/wx-ui/icons/16x16/motherboard.png pcem.png
	make_desktop_entry "pcem" "PCem" pcem "Development;Utility"

	einstalldocs
}

pkg_postinst() {
	elog "In order to use PCem, you will need some roms for various emulated systems."
	elog "You can either install globally for all users or locally for yourself."
	elog ""
	elog "To install globally, put your ROM files into '${ROOT}/usr/share/pcem/roms/<system>'."
	elog "To install locally, put your ROM files into '~/.pcem/roms/<system>'."
}
