# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Software synthesizer capable of making a countless number of instruments"
HOMEPAGE="https://zynaddsubfx.sourceforge.net/"

SRC_URI="
	mirror://sourceforge/zynaddsubfx/${P}.tar.bz2
	mirror://sourceforge/zynaddsubfx/zyn-fusion-ui-src-${PV}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+alsa doc dssi jack lash portaudio"
REQUIRED_USE="|| ( alsa jack portaudio )"

DEPEND="
	dev-libs/mxml
	media-libs/liblo
	sci-libs/fftw:3.0
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	doc? ( dev-texlive/texlive-fontutils )
	dssi? ( media-libs/dssi )
	jack? ( virtual/jack )
	lash? ( media-sound/lash )
	portaudio? ( media-libs/portaudio )
"
RDEPEND="
	${DEPEND}
	media-fonts/roboto
"
BDEPEND="
	dev-lang/ruby:*
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${P}-docs.patch
	"${FILESDIR}"/${P}-stdint.patch
	"${FILESDIR}"/${P}-libzest_location.patch
)
ZYN_FUSION_UI_PATCHES=(
	"${FILESDIR}"/zyn-fusion-ui-${PV}-cflags_ldflags.patch
	"${FILESDIR}"/zyn-fusion-ui-${PV}-libzest_location.patch
	"${FILESDIR}"/zyn-fusion-ui-${PV}-makefile_find.patch
	"${FILESDIR}"/zyn-fusion-ui-${PV}-system_wide_location.patch
)

DOCS=( AUTHORS.txt NEWS.txt README.adoc )

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

	cd ../zyn-fusion-ui-src-${PV}
	eapply "${ZYN_FUSION_UI_PATCHES[@]}"
}

src_configure() {
	append-cxxflags -std=c++11

	local mycmakeargs=(
		-DPluginLibDir=$(get_libdir)
		-DGuiModule=zest
		-DDefaultInput=jack
		-DDefaultOutput=jack
		$(cmake_use_find_package alsa Alsa)
		$(cmake_use_find_package doc Doxygen)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
	emake -C ../zyn-fusion-ui-src-${PV}
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	cmake_src_install

	cd ../zyn-fusion-ui-src-${PV}
	newbin zest zyn-fusion
	insinto /usr/$(get_libdir)/${PN}
	doins libzest.so
	insinto /usr/share/${PN}/qml
	doins -r src/mruby-zest/{example,qml}/*.qml
	insinto /usr/share/${PN}/schema
	doins src/osc-bridge/schema/test.json
}
