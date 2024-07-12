# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs flag-o-matic xdg-utils

DESCRIPTION="Graphical user interface that provides a workflow for HDR imaging"
HOMEPAGE="http://qtpfsgui.sourceforge.net https://github.com/LuminanceHDR/LuminanceHDR"
SRC_URI="https://downloads.sourceforge.net/qtpfsgui/${P/_/.}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="cpu_flags_x86_sse2 fits openmp test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
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
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libraw:=
	>=media-libs/openexr-3:0=
	media-libs/tiff:=
	sci-libs/fftw:3.0=[threads]
	sci-libs/gsl:=
	fits? ( sci-libs/cfitsio:= )
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	test? ( dev-cpp/gtest )
"
BDEPEND="dev-qt/linguist-tools:5"

PATCHES=(
	"${FILESDIR}"/${P}-openexr3.patch
	"${FILESDIR}"/${P}-fixheaders.patch
	"${FILESDIR}"/${PN}-2.6.0-cmake.patch
	"${FILESDIR}"/${PN}-2.6.0-no-git.patch
	"${FILESDIR}"/${PN}-2.6.0-docs.patch
	"${FILESDIR}"/${PN}-2.5.1-openmp-automagic.patch
	"${FILESDIR}"/${PN}-2.6.1.1-boost-1.85.patch
	# patch by ArchLinux
	"${FILESDIR}"/${P}-exiv2-0.28.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	if use cpu_flags_x86_sse2 ; then
		append-flags -msse2
	else
		eerror "This package requires a CPU supporting the SSE2 instruction set."
		die "SSE2 support missing"
	fi

	append-flags -std=c++17

	local mycmakeargs=(
		$(cmake_use_find_package fits CFITSIO)
		-DUSE_OPENMP="$(usex openmp)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	mkdir -p "${D}/usr/share/metainfo" || die
	mv "${D}/usr/share/appdata/"* "${D}/usr/share/metainfo/" || die
	rmdir "${D}/usr/share/appdata" || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
