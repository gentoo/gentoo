# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake readme.gentoo-r1 xdg

DESCRIPTION="Feature-enhanced open source re-implementation of Caesar III"
HOMEPAGE="https://github.com/Keriew/augustus"
SRC_URI="https://github.com/Keriew/augustus/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	dev-libs/expat
	media-libs/libpng:=
	media-libs/libsdl2[joystick,video,sound]
	media-libs/sdl2-mixer
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.1-desktop_rename.patch"
	"${FILESDIR}/${PN}-3.1.0-musl-fix-execinfo.patch"
)

src_install() {
	cmake_src_install
	dodir /usr/libexec
	mv "${ED}/usr/bin/augustus"  "${ED}/usr/libexec/augustus-game" ||
		die "Failed to rename executable (required to set default resources location)."
	newbin - augustus-game <<-EOF
		#!/usr/bin/env sh
		exec "${EPREFIX}/usr/libexec/augustus-game" "\${1:-\${HOME}/.local/share/julius/app}"
	EOF
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
