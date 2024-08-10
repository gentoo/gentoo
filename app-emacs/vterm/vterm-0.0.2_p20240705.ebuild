# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=emacs-libvterm
NEED_EMACS=26

inherit cmake elisp

DESCRIPTION="Fully-featured terminal emulator based on libvterm"
HOMEPAGE="https://github.com/akermu/emacs-libvterm/"

case ${PV} in
	*9999*)
		inherit git-r3
		EGIT_REPO_URI="https://github.com/akermu/${MY_PN}.git"
		;;
	*_p20240705)
		COMMIT=d9ea29fb10aed20512bd95dc5b8c1a01684044b1
		;&			# fall through
	*)
		SRC_URI="https://github.com/akermu/${MY_PN}/archive/${COMMIT:-${PV}}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}/${MY_PN}-${COMMIT:-${PV}}"
		KEYWORDS="amd64 ~arm64 ~x86"
		;;
esac

LICENSE="GPL-3+"
SLOT="0"

DEPEND="
	>=dev-libs/libvterm-0.2:=
"
RDEPEND="
	${DEPEND}
	>=app-editors/emacs-26:*[dynamic-loading]
"

PATCHES=( "${FILESDIR}/${PN}-0.0.1_pre20210618-dont-compile.patch" )

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	if [[ -e ${ESYSROOT}/usr/include/emacs-module.h ]]; then
		# Use system header file instead of bundled one.
		rm emacs-module.h || die
	else
		ewarn "${ESYSROOT}/usr/include/emacs-module.h does not exist"
		ewarn "Falling back to bundled header file"
	fi

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DUSE_SYSTEM_LIBVTERM=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	elisp_src_compile
}

src_install() {
	elisp_src_install
	elisp-modules-install "${PN}" vterm-module.so

	# Install shell-side vterm support scripts.
	insinto "${SITEETC}/${PN}"
	doins -r etc
}
