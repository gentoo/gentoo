# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_COMMIT="607998b9f7e03b05dceed8784207bd0b704f62d4"

DESCRIPTION="A platform independent standalone library that plays Lottie Animations"
HOMEPAGE="https://www.tizen.org/ https://github.com/Samsung/rlottie"
SRC_URI="https://github.com/Samsung/rlottie/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD FTL JSON LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

S="${WORKDIR}/rlottie-${MY_COMMIT}"

PATCHES=( "${FILESDIR}"/rlottie-0.0.1_pre20190920-disable-werror.patch )

src_configure() {
	local emesonargs=(
		-D cache=true
		-D cmake=false
		-D dumptree=false
		-D example=false
		-D log=false
		-D module=true
		-D thread=true
		$(meson_use test)
	)

	meson_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die "Failed to switch into BUILD_DIR."
	eninja test
}
