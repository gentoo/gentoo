# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
VALA_USE_DEPEND="vapigen"

inherit cmake vala virtualx

DESCRIPTION="Ayatana Application Indicators (Shared Library)"
HOMEPAGE="https://github.com/AyatanaIndicators/ayatana-ido"
SRC_URI="https://github.com/AyatanaIndicators/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~loong ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.58:2
	>=x11-libs/gtk+-3.24:3[introspection]
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	$(vala_depend)
	dev-util/glib-utils
	test? ( dev-cpp/gtest )
"

src_prepare() {
	cmake_src_prepare
	vala_setup
}

src_configure() {
	local mycmakeargs+=(
		-DVALA_COMPILER="${VALAC}"
		-DVAPI_GEN="${VAPIGEN}"
		-DENABLE_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
