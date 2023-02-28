# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
VALA_USE_DEPEND="vapigen"

inherit cmake vala virtualx

DESCRIPTION="Ayatana Application Indicators (Shared Library)"
HOMEPAGE="https://github.com/AyatanaIndicators/libayatana-indicator"
SRC_URI="https://github.com/AyatanaIndicators/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/dbus-glib
	>=dev-libs/glib-2.58:2
	>=x11-libs/gtk+-3.24:3[introspection]
	>=dev-libs/ayatana-ido-0.8.2
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	test? ( dev-util/dbus-test-runner )
"

src_prepare() {
	cmake_src_prepare
	vala_setup
}

src_configure() {
	local mycmakeargs+=(
		-DFLAVOUR_GTK2=OFF
		-DFLAVOUR_GTK3=ON
		-DENABLE_IDO=ON
		-DENABLE_LOADER=ON
		-DENABLE_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
