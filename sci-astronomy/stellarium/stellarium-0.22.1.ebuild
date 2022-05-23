# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake desktop flag-o-matic python-any-r1 xdg virtualx

DESCRIPTION="3D photo-realistic skies in real time"
HOMEPAGE="https://stellarium.org/"
MY_DSO_VERSION="3.15"
SRC_URI="
	https://github.com/Stellarium/stellarium/releases/download/v${PV}/${P}.tar.gz
	deep-sky? (
		https://github.com/Stellarium/stellarium-data/releases/download/dso-${MY_DSO_VERSION}/catalog-${MY_DSO_VERSION}.dat -> ${PN}-dso-catalog-${MY_DSO_VERSION}.dat
	)
	doc? (
		https://github.com/Stellarium/stellarium/releases/download/v${PV}/stellarium_user_guide-${PV}-1.pdf
	)
	stars? (
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_4_1v0_2.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_5_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_6_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_7_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_8_2v0_1.cat
	)"

LICENSE="GPL-2+ SGI-B-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~riscv ~x86"
IUSE="debug deep-sky doc gps media nls stars telescope test webengine"

# Python interpreter is used while building RemoteControl plugin
BDEPEND="
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen[dot] )
	nls? ( dev-qt/linguist-tools:5 )
"
RDEPEND="
	dev-libs/qtcompress:=
	dev-qt/qtcharts:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	media-fonts/dejavu
	sys-libs/zlib
	virtual/opengl
	gps? (
		dev-qt/qtpositioning:5
		dev-qt/qtserialport:5
		sci-geosciences/gpsd:=[cxx]
	)
	media? ( dev-qt/qtmultimedia:5[widgets] )
	telescope? (
		dev-qt/qtserialport:5
		sci-libs/indilib:=
	)
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	test? ( dev-qt/qttest:5 )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/stellarium-0.20.3-unbundle-indi.patch"
	"${FILESDIR}/stellarium-0.20.3-unbundle-zlib.patch"
	"${FILESDIR}/stellarium-0.22.1-fix-star-manager-segfault.patch"
	"${FILESDIR}/stellarium-0.22.1-unbundle-qtcompress.patch"
)

src_prepare() {
	cmake_src_prepare
	use debug || append-cppflags -DQT_NO_DEBUG #415769

	# Several libraries are bundled, remove them.
	rm -r src/external/{libindi,qtcompress,zlib}/ || die

	# qcustomplot can't be easily unbundled because it uses qcustomplot 1
	# while we have qcustomplot 2 in tree which changed API a bit
	# Also the license of the external qcustomplot is incompatible with stellarium

	# for glues_stel aka libtess I couldn't find an upstream with the same API

	# unbundling of qxlsx depends on https://github.com/QtExcel/QXlsx/pull/185

	local remaining="$(cd src/external/ && echo */)"
	if [[ "${remaining}" != "glues_stel/ qcustomplot/ qxlsx/" ]]; then
		eqawarn "Need to unbundle more deps: ${remaining}"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_GPS="$(usex gps)"
		-DENABLE_MEDIA="$(usex media)"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_TESTING="$(usex test)"
		-DUSE_PLUGIN_TELESCOPECONTROL="$(usex telescope)"
		$(cmake_use_find_package webengine Qt5WebEngine)
		$(cmake_use_find_package webengine Qt5WebEngineWidgets)
	)
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
