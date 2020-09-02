# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=26
COMMIT="f41849c2c9c1899f22d1c3d4f871ec47c82627ce"

inherit cmake elisp

MY_PN="emacs-libvterm"
DESCRIPTION="Fully-featured terminal emulator based on libvterm"
HOMEPAGE="https://github.com/akermu/emacs-libvterm"
SRC_URI="https://github.com/akermu/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="dev-libs/libvterm"
RDEPEND="${DEPEND}
	>=app-editors/emacs-26:*[dynamic-loading]"

S="${WORKDIR}/${MY_PN}-${COMMIT}"
PATCHES=( "${FILESDIR}"/${PN}-dont-compile.patch )
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=( "-DUSE_SYSTEM_LIBVTERM=ON" )
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	elisp_src_compile
}

src_install() {
	elisp_src_install
	elisp-modules-install ${PN} vterm-module.so
}
