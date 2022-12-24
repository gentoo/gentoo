# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake elisp-common

DESCRIPTION="Graphics Layout Engine"
HOMEPAGE="http://glx.sourceforge.io/ https://github.com/vlabella/GLE/"
IUSE="doc emacs"
LIB_VERSION="d476418f006b001dc7f47dcafb413c0557fa44a7"
SRC_URI="https://github.com/vlabella/GLE/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/vlabella/gle-library/archive/${LIB_VERSION}.tar.gz -> ${PN}-library.tar.gz
	https://dev.gentoo.org/~grozin/gle-c++17.patch.gz
	doc? ( https://dev.gentoo.org/~grozin/gle-manual.pdf.gz )
	emacs? ( https://dev.gentoo.org/~grozin/gle-mode.el.gz )"
S="${WORKDIR}"/GLE-${PV}/src

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-text/ghostscript-gpl
	dev-libs/boost
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-libs/freeglut
	media-libs/glu
	media-libs/libpng
	media-libs/tiff
	sys-libs/zlib
	media-libs/libjpeg-turbo
	x11-libs/cairo
	x11-libs/pixman
	emacs? ( app-editors/emacs:* )"
RDEPEND="${DEPEND}
	virtual/latex-base"

PATCHES=( \
		"${WORKDIR}"/${PN}-c++17.patch \
		"${FILESDIR}"/cairo-pixman.patch \
		"${FILESDIR}"/ghostscript.patch \
		"${FILESDIR}"/link.patch \
		"${FILESDIR}"/array.patch \
		"${FILESDIR}"/wayland.patch \
		"${FILESDIR}"/install.patch \
		"${FILESDIR}"/lic.patch \
	)
SITEFILE="64${PN}-gentoo.el"

src_configure() {
	local mycmakeargs=(
		-DGLE_EXAMPLES_LIBRARY_PATH="${WORKDIR}"/gle-library-${LIB_VERSION}
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use emacs && elisp-compile "${WORKDIR}"/*.el
}

src_install() {
	pushd "${WORKDIR}"/${P}_build > /dev/null || die "pushd failed"
	newbin gle/gle gle.bin
	dobin gui/qgle
	insinto /usr/share/${PN}
	doins gle/glerc
	doins -r gle/font
	popd > /dev/null
	newbin "${FILESDIR}"/gle.sh gle
	dodoc ../doc/README.txt ../doc/ChangeLog.txt
	doins TeX/init.tex
	mv "${WORKDIR}"/gle-library-${LIB_VERSION}/include "${WORKDIR}"/gle-library-${LIB_VERSION}/gleinc || die "mv failed"
	doins -r "${WORKDIR}"/gle-library-${LIB_VERSION}/gleinc
	GLE_TOP="${D}"/usr/share/${PN} "${D}"/usr/bin/gle.bin -mkinittex
	use doc && dodoc "${WORKDIR}"/*.pdf
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
