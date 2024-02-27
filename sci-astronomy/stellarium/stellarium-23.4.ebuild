# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit cmake desktop flag-o-matic python-any-r1 xdg verify-sig virtualx

DESCRIPTION="3D photo-realistic skies in real time"
HOMEPAGE="https://stellarium.org/ https://github.com/Stellarium/stellarium"
MY_DSO_VERSION="3.20"
SRC_URI="
	https://github.com/Stellarium/stellarium/releases/download/v${PV}/${P}.tar.xz
	verify-sig? ( https://github.com/Stellarium/stellarium/releases/download/v${PV}/${P}.tar.xz.asc )
	deep-sky? (
		https://github.com/Stellarium/stellarium-data/releases/download/dso-${MY_DSO_VERSION}/catalog-${MY_DSO_VERSION}.dat -> ${PN}-dso-catalog-${MY_DSO_VERSION}.dat
		verify-sig? ( https://github.com/Stellarium/stellarium-data/releases/download/dso-${MY_DSO_VERSION}/catalog-${MY_DSO_VERSION}.dat.asc -> ${PN}-dso-catalog-${MY_DSO_VERSION}.dat.asc )
	)
	doc? (
		https://github.com/Stellarium/stellarium/releases/download/v${PV}/stellarium_user_guide-${PV}-1.pdf
		verify-sig? ( https://github.com/Stellarium/stellarium/releases/download/v${PV}/stellarium_user_guide-${PV}-1.pdf.asc )
	)
	stars? (
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_4_1v0_2.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_5_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_6_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_7_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_8_2v0_1.cat
	)
	telescope? (
		https://github.com/indilib/indi/archive/v1.8.5.tar.gz -> indilib-1.8.5.tar.gz
	)"

LICENSE="GPL-2+ SGI-B-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug deep-sky doc gps +lens-distortion media nls qt6 +scripting +show-my-sky stars telescope test webengine +xlsx"

# Python interpreter is used while building RemoteControl plugin
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	doc? ( app-text/doxygen[dot] )
	nls? (
		!qt6? ( dev-qt/linguist-tools:5 )
		qt6? ( dev-qt/qttools:6[linguist] )
	)
	verify-sig? ( sec-keys/openpgp-keys-stellarium )
"
RDEPEND="
	media-fonts/dejavu
	sys-libs/zlib
	gps? ( sci-geosciences/gpsd:=[cxx] )
	lens-distortion? (
		media-gfx/exiv2:=
		sci-libs/nlopt
	)
	media? ( virtual/opengl )
	!qt6? (
		dev-qt/qtcharts:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5=
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		>=sci-astronomy/calcmysky-0.3.0:=[qt5]
		gps? (
			dev-qt/qtpositioning:5
			dev-qt/qtserialport:5
		)
		media? (
			dev-qt/qtmultimedia:5[widgets]
			dev-qt/qtopengl:5
		)
		scripting? ( dev-qt/qtscript:5 )
		telescope? ( dev-qt/qtserialport:5 )
		webengine? ( dev-qt/qtwebengine:5[widgets] )
		xlsx? ( dev-libs/qxlsx:=[qt5] )
	)
	qt6? (
		dev-qt/qtbase:6=[gui,network,widgets]
		dev-qt/qtcharts:6
		>=sci-astronomy/calcmysky-0.3.0:=[qt6]
		gps? (
			dev-qt/qtpositioning:6
			dev-qt/qtserialport:6
		)
		media? (
			dev-qt/qtmultimedia:6[gstreamer]
		)
		scripting? ( dev-qt/qtdeclarative:6 )
		telescope? ( dev-qt/qtserialport:6 )
		webengine? ( dev-qt/qtwebengine:6[widgets] )
		xlsx? ( dev-libs/qxlsx:=[qt6] )
	)
"
DEPEND="${RDEPEND}
	!qt6? (
		dev-qt/qtconcurrent:5
		test? ( dev-qt/qttest:5 )
	)
	qt6? ( dev-qt/qtbase:6=[concurrent] )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/stellarium-0.23.4-unbundle-zlib.patch"
)

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/stellarium.asc
src_unpack() {
	# stars-2.0 are not signed
	if use verify-sig; then
		pushd "${DISTDIR}" > /dev/null || die
		verify-sig_verify_detached \
			${P}.tar.xz{,.asc}
		use deep-sky && verify-sig_verify_detached \
			${PN}-dso-catalog-${MY_DSO_VERSION}.dat{,.asc}
		use doc && verify-sig_verify_detached \
			stellarium_user_guide-${PV}-1.pdf{,.asc}
		popd > /dev/null || die
	fi
	default_src_unpack
}

src_prepare() {
	cmake_src_prepare
	use debug || append-cppflags -DQT_NO_DEBUG #415769

	rm -r src/external/zlib/ || die

	# for glues_stel aka libtess I couldn't find an upstream with the same API

	local remaining="$(cd src/external/ && echo */)"
	if [[ "${remaining}" != "glues_stel/" ]]; then
		eqawarn "Need to unbundle more deps: ${remaining}"
	fi
}

src_configure() {
	filter-lto # https://bugs.gentoo.org/862249

	local mycmakeargs=(
		-DCCACHE_PROGRAM=no
		-DCPM_LOCAL_PACKAGES_ONLY=yes
		-DENABLE_GPS="$(usex gps)"
		-DENABLE_MEDIA="$(usex media)"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_QT6="$(usex qt6)"
		-DENABLE_QTWEBENGINE="$(usex webengine)"
		-DENABLE_SHOWMYSKY=$(usex show-my-sky)
		-DENABLE_SCRIPTING=$(usex scripting)
		-DENABLE_TESTING="$(usex test)"
		-DENABLE_XLSX="$(usex xlsx)"
		-DUSE_PLUGIN_LENSDISTORTIONESTIMATOR="$(usex lens-distortion)"
		-DUSE_PLUGIN_TELESCOPECONTROL="$(usex telescope)"
		"$(cmake_use_find_package doc Doxygen)"
	)
	if use telescope; then
		# https://bugs.gentoo.org/913177
		mycmakeargs+=(
			-DPREFER_SYSTEM_INDILIB=no
			-DCPM_indiclient_SOURCE="${WORKDIR}/indi-1.8.5"
		)
	fi
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		cmake_build apidoc
	fi
}

src_install() {
	if use doc ; then
		local HTML_DOCS=( "${BUILD_DIR}/doc/html/." )
		dodoc "${DISTDIR}/stellarium_user_guide-${PV}-1.pdf"
	fi
	cmake_src_install

	# use the more up-to-date system fonts
	rm "${ED}"/usr/share/stellarium/data/DejaVuSans{Mono,}.ttf || die
	dosym ../../fonts/dejavu/DejaVuSans.ttf /usr/share/stellarium/data/DejaVuSans.ttf
	dosym ../../fonts/dejavu/DejaVuSansMono.ttf /usr/share/stellarium/data/DejaVuSansMono.ttf

	if use stars ; then
		insinto /usr/share/${PN}/stars/default
		doins "${DISTDIR}"/stars_4_1v0_2.cat
		doins "${DISTDIR}"/stars_{5,6,7,8}_2v0_1.cat
	fi
	if use deep-sky ; then
		insinto /usr/share/${PN}/nebulae/default
		newins "${DISTDIR}/${PN}-dso-catalog-${MY_DSO_VERSION}.dat" catalog.dat
	fi
	newicon doc/images/stellarium-logo.png ${PN}.png
}
