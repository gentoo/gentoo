# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="melonDS"
MY_P="${MY_PN}-${PV}"

inherit cmake readme.gentoo-r1 toolchain-funcs xdg

DESCRIPTION="Nintendo DS emulator, sorta"
HOMEPAGE="
	http://melonds.kuribo64.net
	https://github.com/Arisotura/melonDS
"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Arisotura/${MY_PN}.git"
else
	SRC_URI="https://github.com/Arisotura/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

IUSE="+jit +opengl"
LICENSE="BSD-2 GPL-2 GPL-3 Unlicense"
SLOT="0"

DEPEND="
	app-arch/libarchive
	dev-libs/teakra
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libsdl2[sound,video]
	net-libs/libpcap
	net-libs/libslirp
	opengl? ( media-libs/libepoxy )
"
RDEPEND="${DEPEND}"

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

src_configure() {
	local mycmakeargs=(
		-DENABLE_JIT=$(usex jit)
		-DENABLE_OGLRENDERER=$(usex opengl)
	)
	cmake_src_configure
}

src_compile() {
	tc-export AR
	cmake_src_compile
}

src_install() {
	cmake_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
