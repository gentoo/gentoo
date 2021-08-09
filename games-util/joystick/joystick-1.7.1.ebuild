# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="linuxconsoletools-${PV}"

DESCRIPTION="Joystick testing utilities"
HOMEPAGE="https://sourceforge.net/projects/linuxconsole/"
SRC_URI="mirror://sourceforge/linuxconsole/files/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="sdl udev"

DEPEND="sdl? ( media-libs/libsdl2[video] )"
RDEPEND="
	${DEPEND}
	udev? ( virtual/udev )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-build.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
	export PREFIX="${EPREFIX}"/usr
	export USE_SDL=$(usex sdl)
}

src_install() {
	default

	if ! use udev; then
		rm "${ED}"/usr/bin/jscal-{re,}store || die
	fi

	if [[ ${EPREFIX} ]]; then
		mv {"${D}","${ED}"}/lib || die
	fi
}
