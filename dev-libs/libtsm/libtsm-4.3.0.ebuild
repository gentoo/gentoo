# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Terminal Emulator State Machine"
HOMEPAGE="https://github.com/Aetf/libtsm"
SRC_URI="https://github.com/Aetf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MIT"
SLOT="0/4"
KEYWORDS="amd64 x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

# Needed for xkbcommon-keysyms.h
DEPEND="x11-libs/libxkbcommon
	test? ( dev-libs/check )"

src_configure() {
	local emesonargs=(
		-Dtests=$(usex test true false)
		-Dextra_debug=$(usex debug true false)
		-Dgtktsm=false
		)

	meson_src_configure
}
