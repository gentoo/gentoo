# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
inherit cmake elisp-common flag-o-matic

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
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/pixman
	gui? (
		media-libs/freeglut
		media-libs/glu
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
	manip? ( sys-libs/ncurses:0 )
	emacs? ( app-editors/emacs:* )"
RDEPEND="${DEPEND}
	virtual/latex-base"
BDEPEND="kde-frameworks/extra-cmake-modules
	doc? ( virtual/latex-base )"

PATCHES=(
	"${FILESDIR}"/cmake-cmp0177.patch
	"${FILESDIR}"/install-dirs.patch
	"${FILESDIR}"/top_dir.patch
	"${FILESDIR}"/zstd-shared.patch
)
SITEFILE="64${PN}-gentoo.el"

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/927779
	# https://github.com/vlabella/GLE/issues/35
	filter-lto

	local mycmakeargs=(
		-DGLEDOC=share/doc/${PF}
		-DGLE_EXAMPLES_LIBRARY_PATH="${WORKDIR}"/gle-library-${PV}
		-DBUILD_GUI=$(usex gui)
		-DBUILD_MANIP=$(usex manip)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use emacs && elisp-compile "${WORKDIR}"/*.el

	# I don't really understand why is this hack needed
	sed -e 's/|+//' -i "${BUILD_DIR}"/gle/cmake_install.cmake
}

src_install() {
	export GLE_TOP="${D}"/usr/share/gle
	cmake_src_install
	#GLE_TOP="${D}"/usr/share/${PN} "${D}"/usr/bin/gle.bin -mkinittex
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
