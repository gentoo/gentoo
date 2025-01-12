# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REAL_PN="melonDS"
REAL_PV="${PV/_rc/rc}"
REAL_P="${REAL_PN}-${REAL_PV}"

inherit cmake readme.gentoo-r1 toolchain-funcs xdg

DESCRIPTION="Nintendo DS emulator, sorta"
HOMEPAGE="http://melonds.kuribo64.net
	https://github.com/Arisotura/melonDS"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Arisotura/${REAL_PN}"
else
	SRC_URI="https://github.com/Arisotura/${REAL_PN}/archive/${REAL_PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${REAL_P}"

	KEYWORDS="~amd64"
fi

LICENSE="BSD-2 GPL-2 GPL-3 Unlicense"
SLOT="0"
IUSE="+jit +opengl wayland"

RDEPEND="
	app-arch/libarchive[zstd]
	dev-qt/qtbase:6[network,opengl,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
	media-libs/libsdl2[sound,video]
	net-libs/enet:=
	net-libs/libpcap
	net-libs/libslirp
	x11-libs/libxkbcommon
	wayland? (
		dev-libs/wayland
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	wayland? (
		kde-frameworks/extra-cmake-modules:0
	)
"

# Used for JIT recompiler.
QA_EXECSTACK="usr/bin/melonDS"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You need the following files in order to run melonDS:
- bios7.bin
- bios9.bin
- firmware.bin
- romlist.bin
Place them in ~/.config/melonDS
Those files can be extracted from devices or found somewhere on the Internet ;-)"

src_configure() {
	local -a mycmakeargs=(
		-DBUILD_SHARED_LIBS="OFF"
		-DUSE_SYSTEM_LIBSLIRP="ON"

		-DENABLE_JIT="$(usex jit)"
		-DENABLE_OGLRENDERER="$(usex opengl)"
		-DENABLE_WAYLAND="$(usex wayland)"
	)
	cmake_src_configure
}

src_compile() {
	tc-export AR
	cmake_src_compile
}

src_install() {
	readme.gentoo_create_doc
	cmake_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
