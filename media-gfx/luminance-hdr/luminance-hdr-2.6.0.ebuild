# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs flag-o-matic xdg-utils

DESCRIPTION="Graphical user interface that provides a workflow for HDR imaging"
HOMEPAGE="http://qtpfsgui.sourceforge.net https://github.com/LuminanceHDR/LuminanceHDR"
SRC_URI="mirror://sourceforge/qtpfsgui/${P/_/.}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cpu_flags_x86_sse2 fits openmp test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-libs/boost:0=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/exiv2:=
	media-libs/ilmbase:=
	media-libs/lcms:2
	media-libs/libpng:0=
	media-libs/libraw:=
	media-libs/openexr:=
	media-libs/tiff:0
	sci-libs/fftw:3.0=[threads]
	sci-libs/gsl:=
	virtual/jpeg:0
	fits? ( sci-libs/cfitsio:= )
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-no-git.patch
	"${FILESDIR}"/${P}-docs.patch
	"${FILESDIR}"/${PN}-2.5.1-openmp-automagic.patch
)

pkg_pretend() {
	if use cpu_flags_x86_sse2 ; then
		append-flags -msse2
	else
		eerror "This package requires a CPU supporting the SSE2 instruction set."
		die "SSE2 support missing"
	fi

	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package fits CFITSIO)
		-DUSE_OPENMP="$(usex openmp)"
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
