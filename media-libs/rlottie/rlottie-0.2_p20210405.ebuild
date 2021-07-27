# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_COMMIT="7c5b40cbb87422e5a74691d4d9907948c8c0d479"

DESCRIPTION="A platform independent standalone library that plays Lottie Animations"
HOMEPAGE="https://www.tizen.org/ https://github.com/Samsung/rlottie"
SRC_URI="https://github.com/Samsung/rlottie/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD FTL JSON MIT"
SLOT="0/0.2"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="debug test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

S="${WORKDIR}/rlottie-${MY_COMMIT}"

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
