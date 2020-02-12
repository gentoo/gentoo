# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_COMMIT="87f485e2247925ceaead99c4bca997e4c44e3a20"

DESCRIPTION="A platform independent standalone library that plays Lottie Animations"
HOMEPAGE="https://www.tizen.org/ https://github.com/Samsung/rlottie"
SRC_URI="https://github.com/Samsung/rlottie/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD FTL LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

S="${WORKDIR}/rlottie-${MY_COMMIT}"

PATCHES=( "${FILESDIR}"/rlottie-0.0.1_pre20190920-disable-werror.patch )

src_configure() {
	local emesonargs=(
		-D example=false
		$(meson_use test)
	)

	meson_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die "Failed to switch into BUILD_DIR."
	eninja test
}
