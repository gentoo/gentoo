# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A platform independent standalone library that plays Lottie Animations"
HOMEPAGE="https://www.tizen.org/ https://github.com/Samsung/rlottie"
SRC_URI="https://github.com/Samsung/rlottie/archive/v${PV}.tar.gz -> ${P}-1.tar.gz"

LICENSE="BSD FTL JSON MIT"
SLOT="0/0.2"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug examples test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

src_configure() {
	local emesonargs=(
		-D cache=true
		-D module=true
		-D thread=true

		-D cmake=false
		-D example=false

		$(meson_use debug dumptree)
		$(meson_use debug log)
		$(meson_use test)
	)

	meson_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die "Failed to switch into BUILD_DIR."
	eninja test
}
