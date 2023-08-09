# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=emacs-libvterm

NEED_EMACS=26

inherit cmake elisp

DESCRIPTION="Fully-featured terminal emulator based on libvterm"
HOMEPAGE="https://github.com/akermu/emacs-libvterm/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/akermu/${MY_PN}.git"
else
	if [[ ${PV} = *_p20230217 ]] ; then
		COMMIT=3e5a9b754b8e61850bb7d1b63b090b9fbf6687f3
		SRC_URI="https://github.com/akermu/${MY_PN}/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${MY_PN}-${COMMIT}
	else
		SRC_URI="https://github.com/akermu/${MY_PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${MY_PN}-${PV}
	fi
	KEYWORDS="amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DEPEND=">=dev-libs/libvterm-0.2:="
RDEPEND="
	${DEPEND}
	>=app-editors/emacs-26:*[dynamic-loading]
"

PATCHES=( "${FILESDIR}"/${PN}-0.0.1_pre20210618-dont-compile.patch )

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	if [[ -e ${ESYSROOT}/usr/include/emacs-module.h ]] ; then
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
	elisp-modules-install ${PN} vterm-module.so

	# Install shell-side vterm support scripts.
	insinto "${SITEETC}"/${PN}
	doins -r etc
}
