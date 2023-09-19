# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake readme.gentoo-r1

DESCRIPTION="Feature-faithful open source re-implementation of Caesar III"
HOMEPAGE="https://github.com/bvschaik/julius"
SRC_URI="https://github.com/bvschaik/julius/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	media-libs/libpng:=
	media-libs/libsdl2[joystick,video,sound]
	media-libs/sdl2-mixer
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1-rename.patch
	"${FILESDIR}"/${PN}-1.6.0-musl-fix-execinfo.patch
)

src_install() {
	cmake_src_install
	dodir /usr/libexec
	mv "${ED}/usr/bin/julius-game"  "${ED}/usr/libexec/julius-game" ||
		die "Failed to rename executable (required to set default resources location)."
	newbin - julius-game <<-EOF
		#!/usr/bin/env sh
		exec "${EPREFIX}/usr/libexec/julius-game" "\${1:-\${HOME}/.local/share/julius/app}"
	EOF
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
