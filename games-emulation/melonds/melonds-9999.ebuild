# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="melonDS"
MY_P="${MY_PN}-${PV}"

inherit cmake flag-o-matic readme.gentoo-r1 toolchain-funcs xdg

DESCRIPTION="Nintendo DS emulator, sorta"
HOMEPAGE="http://melonds.kuribo64.net
	https://github.com/Arisotura/melonDS"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Arisotura/${MY_PN}.git"
else
	SRC_URI="https://github.com/Arisotura/${MY_PN}/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
	S="${WORKDIR}"/${MY_P}
	KEYWORDS="~amd64"
fi

IUSE="+jit +opengl wayland"
LICENSE="BSD-2 GPL-2 GPL-3 Unlicense"
SLOT="0"

RDEPEND="
	app-arch/libarchive
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libsdl2[sound,video]
	net-libs/libpcap
	net-libs/libslirp
	wayland? ( dev-libs/wayland )
"
DEPEND="${RDEPEND}"
BDEPEND="wayland? ( kde-frameworks/extra-cmake-modules:0 )"

# used for JIT recompiler
QA_EXECSTACK="usr/bin/melonDS"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You need the following files in order to run melonDS:
- bios7.bin
- bios9.bin
- firmware.bin
- romlist.bin
Place them in ~/.config/melonDS
Those files can be found somewhere on the Internet ;-)"

src_prepare() {
	filter-lto
	append-flags -fno-strict-aliasing

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DENABLE_JIT=$(usex jit)
		-DENABLE_OGLRENDERER=$(usex opengl)
		-DENABLE_WAYLAND=$(usex wayland)
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
