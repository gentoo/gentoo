# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg-utils virtualx

MY_P=synergy-core-${PV}-stable
GTEST_COMMIT=18f8200e3079b0e54fa00cb7ac55d4c39dcf6da6

DESCRIPTION="Lets you easily share a single mouse and keyboard between multiple computers"
HOMEPAGE="https://symless.com/synergy https://github.com/symless/synergy-core/"
SRC_URI="
	https://github.com/symless/${PN}-core/archive/${PV}-stable.tar.gz
		-> ${MY_P}.tar.gz
	https://dev.gentoo.org/~mgorny/dist/synergy-1.12.0.png
	test? (
		https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz
			-> googletest-${GTEST_COMMIT}.tar.gz
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="libressl gui test zeroconf"
RESTRICT="!test? ( test )"

RDEPEND="
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
	x11-libs/libICE:=
	x11-libs/libSM:=
	x11-libs/libX11:=
	x11-libs/libXext:=
	x11-libs/libXi:=
	x11-libs/libXinerama:=
	x11-libs/libXrandr:=
	x11-libs/libXtst:=
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		zeroconf? (
			net-dns/avahi[mdnsresponder-compat]
		)
	)
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	gui? (
		dev-qt/linguist-tools:5
	)"

DOCS=( ChangeLog doc/synergy.conf.example{,-advanced,-basic} )

src_prepare() {
	# broken on Xvfb
	rm src/test/integtests/platform/XWindowsScreenTests.cpp || die

	if use test; then
		rmdir ext/googletest || die
		mv "${WORKDIR}/googletest-${GTEST_COMMIT}" ext/googletest || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSYNERGY_BUILD_LEGACY_GUI=$(usex gui)
		-DSYNERGY_BUILD_LEGACY_INSTALLER=OFF
		-DBUILD_TESTS=$(usex test)
		-DSYNERGY_AUTOCONFIG=$(usex zeroconf)
	)

	cmake_src_configure
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

	if use gui; then
		newbin "${BUILD_DIR}"/bin/synergy qsynergy
		newicon -s 256 "${DISTDIR}"/synergy-1.12.0.png qsynergy.png
		make_desktop_entry qsynergy Synergy qsynergy 'Utility;'
	fi

	insinto /etc
	newins doc/synergy.conf.example synergy.conf

	newman doc/synergyc.man synergyc.1
	newman doc/synergys.man synergys.1

	einstalldocs
}

pkg_postinst() {
	use gui && xdg_icon_cache_update
}

pkg_postrm() {
	use gui && xdg_icon_cache_update
}
