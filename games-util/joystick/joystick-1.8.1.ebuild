# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs udev

MY_P="linuxconsoletools-${PV}"

DESCRIPTION="Joystick testing utilities"
HOMEPAGE="https://sourceforge.net/projects/linuxconsole/"
SRC_URI="mirror://sourceforge/linuxconsole/files/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="sdl"

RDEPEND="sdl? ( media-libs/libsdl2[video] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.1-optional-ffmvforce.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
	export PREFIX="${EPREFIX}"/usr
	use sdl || export DISABLE_FFMVFORCE=1
}

src_install() {
	default

	[[ ! ${EPREFIX} ]] || mv {"${D}","${ED}"}/lib || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
