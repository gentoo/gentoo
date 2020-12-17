# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Feature-faithful open source re-implementation of Caesar III"
HOMEPAGE="https://github.com/bvschaik/julius"
SRC_URI="https://github.com/bvschaik/julius/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	media-libs/libpng:0=
	media-libs/libsdl2[joystick,video,sound]
	media-libs/sdl2-mixer
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
	xdg_src_prepare
}

src_install() {
	insinto /etc/profile.d
	doins "${FILESDIR}"/90julius.sh
	cmake_src_install
	mv "${ED}"/usr/bin/julius  "${ED}"/usr/bin/julius-game ||
		die "Failed to rename executable (required as per conflict with app-accessibility/julius)"
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn "Julius requires you to download the original Caesar 3 resources."
	ewarn
	ewarn "You need to obtain these files from a vendor of the proprietary software."
	ewarn "You will then need to copy the 'app' directory into '~/.cache/julius/'."
	ewarn "One way to obtain this directory is to download the GOG Cesar 3 edition."
	ewarn "You can then produce this directory by running:"
	ewarn "    innoextract -m setup_caesar3_2.0.0.9.exe"
	ewarn
	ewarn "Lastly, run 'source /etc/profile' to refresh your environment and be able"
	ewarn "to start the game directly by running 'julius-game' in the command line."
}
