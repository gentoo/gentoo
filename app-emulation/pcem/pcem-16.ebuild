# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop wxwidgets

WX_GTK_VER="3.0"

DESCRIPTION="A PC emulator that specializes in running old operating systems and software"
HOMEPAGE="
	https://pcem-emulator.co.uk/
	https://bitbucket.org/pcem_emulator/pcem/
"
SRC_URI="https://pcem-emulator.co.uk/files/PCemV${PV}Linux.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa networking"

S="${WORKDIR}"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	media-libs/libsdl2
	media-libs/openal
	x11-libs/wxGTK:${WX_GTK_VER}[tiff,X]
"

DEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-15-respect-cflags.patch" )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Does not compile with -fno-common.
	# See https://pcem-emulator.co.uk/phpBB3/viewtopic.php?f=3&t=3443
	append-cflags -fcommon

	local myeconfargs=(
		--enable-release-build
		$(use_enable alsa)
		$(use_enable networking)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /usr/share/pcem
	doins -r configs nvr roms

	newicon src/icons/32x32/motherboard.png pcem.png
	make_desktop_entry "pcem" "PCem" pcem "Development;Utility"

	dodoc readme.txt
}

pkg_postinst() {
	elog "In order to use PCem, you will need some roms for various emulated systems."
	elog "You can either install globally for all users or locally for yourself."
	elog ""
	elog "To install globally, put your ROM files into '${ROOT}/usr/share/pcem/roms/<system>'."
	elog "To install locally, put your ROM files into '~/.pcem/roms/<system>'."
}
