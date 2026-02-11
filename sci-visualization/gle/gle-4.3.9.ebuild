# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
inherit cmake elisp-common

DESCRIPTION="Graphics Layout Engine"
HOMEPAGE="https://glx.sourceforge.io/ https://github.com/vlabella/GLE/"
SRC_URI="https://github.com/vlabella/GLE/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/vlabella/gle-library/archive/refs/tags/v${PV}.tar.gz -> ${PN}-library-${PV}.tar.gz
	doc? ( https://github.com/vlabella/gle-manual/archive/refs/tags/v${PV}.tar.gz -> ${PN}-manual-${PV}.tar.gz )
	emacs? ( https://dev.gentoo.org/~grozin/gle-mode.el.gz )"
S="${WORKDIR}"/GLE-${PV}/src
LICENSE="BSD gui? ( GPL-2+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc emacs gui manip"

DEPEND="app-text/ghostscript-gpl
	app-text/poppler
	dev-libs/boost
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/tiff
	virtual/zlib:=
	x11-libs/cairo
	x11-libs/pixman
	gui? (
		media-libs/freeglut
		media-libs/glu
		dev-qt/qtbase[dbus,gui,network,opengl,widgets]
	)
	manip? ( sys-libs/ncurses:0 )
	emacs? ( app-editors/emacs:* )"
RDEPEND="${DEPEND}
	virtual/latex-base"
BDEPEND=">=dev-build/cmake-3.31
	kde-frameworks/extra-cmake-modules
	doc? ( virtual/latex-base )"

SITEFILE="64${PN}-gentoo.el"

src_configure() {
	local mycmakeargs=(
		-DGLE_EXAMPLES_LIBRARY_PATH="${WORKDIR}"/gle-library-${PV}
		-DBUILD_GUI=$(usex gui)
		-DBUILD_MANIP=$(usex manip)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use emacs && elisp-compile "${WORKDIR}"/*.el
}

src_install() {
	cmake_src_install
	dosym -r /usr/share/doc/${PF} /usr/share/${PN}-graphics/doc
	if use doc; then
		pushd "$WORKDIR"/gle-manual-${PV} > /dev/null || die "pushd gle_manual failed"
		export PATH="${D}"/usr/bin:${PATH}
		make -f Makefile.gcc GLE="${D}"/usr/bin/gle
		dodoc gle-manual.pdf
		popd > /dev/null
	fi
	if use emacs; then
		elisp-install ${PN} "${WORKDIR}"/*.el "${WORKDIR}"/*.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
