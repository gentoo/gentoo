# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="C library for arbitrary-precision interval arithmetic"
HOMEPAGE="https://fredrikj.net/arb/"
SRC_URI="https://github.com/fredrik-johansson/arb/archive/${PV}.tar.gz -> ${P}.tar.gz"
IUSE="test"

RESTRICT="!test? ( test )"

LICENSE="GPL-2+"
SLOT="0/2"
KEYWORDS="amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	>=sci-mathematics/flint-2.5.0:="

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.18.0-multilib-strict.patch
	"${FILESDIR}"/${PN}-2.18.0-build_type.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
	)

	cmake-utils_src_configure
}
