# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
VALA_USE_DEPEND="vapigen"

inherit cmake vala virtualx

DESCRIPTION="Ayatana Application Indicators (Shared Library)"
HOMEPAGE="https://github.com/AyatanaIndicators/libayatana-appindicator"
SRC_URI="https://github.com/AyatanaIndicators/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.37:2
	>=x11-libs/gtk+-3.24:3[introspection]
	dev-libs/libdbusmenu[gtk3]
	>=dev-libs/libayatana-indicator-0.8.4
"
DEPEND="${RDEPEND}"
BDEPEND="$(vala_depend)
	test? ( dev-util/dbus-test-runner )
"

PATCHES=(
	"${FILESDIR}"/libayatana-appindicator-0.5.93-correct-symbols-in-version-script.patch
)

src_prepare() {
	vala_setup
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs+=(
		-DVALA_COMPILER="${VALAC}"
		-DVAPI_GEN="${VAPIGEN}"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_GTKDOC=OFF
		-DENABLE_BINDINGS_MONO=OFF
		-DFLAVOUR_GTK2=OFF
		-DFLAVOUR_GTK3=ON
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
