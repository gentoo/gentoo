# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Software synthesizer capable of making a countless number of instruments"
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa doc dssi +fltk jack lash portaudio"

REQUIRED_USE="|| ( alsa jack portaudio )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
DEPEND="
	>=dev-libs/mxml-2.2.1
	media-libs/liblo
	sci-libs/fftw:3.0
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	dssi? ( media-libs/dssi )
	fltk? (
		>=x11-libs/fltk-1.3:1
		x11-libs/libX11
		x11-libs/libXpm
	)
	jack? ( virtual/jack )
	lash? ( media-sound/lash )
	portaudio? ( media-libs/portaudio )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-docs.patch )

DOCS=( ChangeLog HISTORY.txt README.adoc )

src_prepare() {
	cmake_src_prepare

	if ! use dssi; then
		sed -i -e '/pkg_search_module.*DSSI/s/^/#DONT/' src/CMakeLists.txt || die
	fi
	if ! use jack; then
		sed -e '/pkg_check_modules.*JACK/s/^/#DONT/' -i {rtosc,src}/CMakeLists.txt || die
	fi
	if ! use lash; then
		sed -i -e '/pkg_search_module.*LASH/s/^/#DONT/' src/CMakeLists.txt || die
	fi
	if ! use portaudio; then
		sed -i -e '/pkg_check_modules.*PORTAUDIO/s/^/#DONT/' src/CMakeLists.txt || die
	fi

	# FIXME upstream: sandbox error
	sed -i -e '/add_subdirectory(bash-completion)/d' doc/CMakeLists.txt || die
}

src_configure() {
	append-cxxflags -std=c++11

	local mycmakeargs=(
		-DPluginLibDir=$(get_libdir)
		$(cmake_use_find_package alsa Alsa)
		$(cmake_use_find_package doc Doxygen)
		$(cmake_use_find_package fltk FLTK)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	cmake_src_install
	insinto /usr/share/${PN}
	doins -r instruments/*
}
