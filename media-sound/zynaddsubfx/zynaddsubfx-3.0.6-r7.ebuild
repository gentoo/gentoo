# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic prefix toolchain-funcs

DESCRIPTION="Software synthesizer capable of making a countless number of instruments"
HOMEPAGE="https://zynaddsubfx.sourceforge.net/"

SRC_URI="
	https://downloads.sourceforge.net/zynaddsubfx/${P}.tar.bz2
	https://downloads.sourceforge.net/zynaddsubfx/zyn-fusion-ui-src-${PV}.tar.bz2
"
S_ZYN_FUSION_UI="${WORKDIR}"/zyn-fusion-ui-src-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+alsa doc dssi jack lash portaudio"
REQUIRED_USE="|| ( alsa jack portaudio )"

DEPEND="
	dev-libs/mxml:0
	media-libs/liblo
	sci-libs/fftw:3.0
	virtual/zlib:=
	virtual/opengl
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
	doc? ( app-text/doxygen[dot] )
"

PATCHES=(
	"${FILESDIR}"/${P}-docs.patch
	"${FILESDIR}"/${P}-stdint.patch
	"${FILESDIR}"/${P}-libzest_location.patch
	"${FILESDIR}"/${P}-cmake4.patch # bug 957633, in git master
)
ZYN_FUSION_UI_PATCHES=(
	"${FILESDIR}"/zyn-fusion-ui-${PV}-cflags_ldflags.patch
	"${FILESDIR}"/zyn-fusion-ui-${PV}-libzest_location.patch
	"${FILESDIR}"/zyn-fusion-ui-${PV}-makefile_find.patch
	"${FILESDIR}"/zyn-fusion-ui-${PV}-system_wide_location.patch
)

DOCS=( AUTHORS.txt NEWS.txt README.adoc )

src_prepare() {
	pushd DPF > /dev/null || die
		eapply "${FILESDIR}"/${P}-DPF-cmake4.patch # bug 957633, in git master
	popd > /dev/null || die

	pushd rtosc > /dev/null || die
		eapply "${FILESDIR}"/${P}-rtosc-cmake4.patch # bug 957633, in git master
		eapply "${FILESDIR}"/${P}-fix-Wnonnull-warning.patch # in git master
	popd > /dev/null || die

	pushd "${S_ZYN_FUSION_UI}" > /dev/null || die
		eapply "${ZYN_FUSION_UI_PATCHES[@]}"
	popd > /dev/null || die

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
	cmake_comment_add_subdirectory -f doc bash-completion

	sed -i "s|@GENTOO_LIBDIR@|$(get_libdir)|" \
		src/Plugin/ZynAddSubFX/ZynAddSubFX-UI-Zest.cpp \
		"${S_ZYN_FUSION_UI}"/test-libversion.c || die

	eprefixify \
		src/Plugin/ZynAddSubFX/ZynAddSubFX-UI-Zest.cpp \
		"${S_ZYN_FUSION_UI}"/test-libversion.c
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
	emake \
		LD="$(tc-getCC)" \
		-C "${S_ZYN_FUSION_UI}"
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	cmake_src_install

	pushd "${S_ZYN_FUSION_UI}" > /dev/null || die
		newbin zest zyn-fusion
		insinto /usr/$(get_libdir)/${PN}
		doins libzest.so
		insinto /usr/share/${PN}/qml
		doins -r src/mruby-zest/{example,qml}/*.qml
		insinto /usr/share/${PN}/schema
		doins src/osc-bridge/schema/test.json
	popd > /dev/null || die
}
