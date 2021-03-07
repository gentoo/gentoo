# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop gnome2-utils virtualx

DESCRIPTION="Lets you easily share a single mouse and keyboard between multiple computers"
HOMEPAGE="https://symless.com/synergy https://github.com/symless/synergy-core"
SRC_URI="
	https://github.com/symless/${PN}-core/archive/v${PV}-stable.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~jer/${PN}.png
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="libressl qt5 test"
RESTRICT="!test? ( test )"

S=${WORKDIR}/${PN}-core-${PV}-stable

COMMON_DEPEND="
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
	net-misc/curl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		net-dns/avahi[mdnsresponder-compat]
	)
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="
	${COMMON_DEPEND}
	qt5? ( !x11-misc/qsynergy )
"

DOCS=( ChangeLog doc/synergy.conf.example{,-advanced,-basic} )

PATCHES=(
	"${FILESDIR}"/${P}-pthread.patch
	"${FILESDIR}"/${P}-cmake-version.patch
	"${FILESDIR}"/${P}-qt-5.11.patch
	"${FILESDIR}"/${P}-test.patch
)

src_prepare() {
	# requires Internet, and relies on old site anyway
	rm src/test/integtests/arch/ArchInternetTests.cpp || die
	# broken on Xvfb
	rm src/test/integtests/platform/XWindowsScreenTests.cpp || die

	cmake-utils_src_prepare
}

src_configure() {
	# otherwise unit tests segfault
	local -x CFLAGS="${CFLAGS} -O0"
	local -x CXXFLAGS="${CXXFLAGS} -O0"

	local mycmakeargs=(
		-DSYNERGY_BUILD_LEGACY_GUI=$(usex qt5)
		-DSYNERGY_BUILD_LEGACY_INSTALLER=OFF
		-DBUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}

my_test() {
	"${BUILD_DIR}"/bin/unittests &&
	"${BUILD_DIR}"/bin/integtests
}

src_test() {
	virtx my_test
}

src_install() {
	dobin "${BUILD_DIR}"/bin/{synergy{c,s},syntool}

	if use qt5 ; then
		newbin "${BUILD_DIR}"/bin/${PN} qsynergy
		newicon -s 256 "${DISTDIR}"/${PN}.png q${PN}.png
		make_desktop_entry q${PN} ${PN/s/S} q${PN} Utility;
	fi

	insinto /etc
	newins doc/synergy.conf.example synergy.conf

	newman doc/${PN}c.man ${PN}c.1
	newman doc/${PN}s.man ${PN}s.1

	einstalldocs
}

pkg_preinst() {
	use qt5 && gnome2_icon_savelist
}

pkg_postinst() {
	use qt5 && gnome2_icon_cache_update
}

pkg_postrm() {
	use qt5 && gnome2_icon_cache_update
}
