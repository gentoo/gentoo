# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson multilib-minimal

DESCRIPTION="A simple, small, efficient, C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml2/ https://github.com/leethomason/tinyxml2/"
SRC_URI="https://github.com/leethomason/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/8"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-meson-typo.patch
)

multilib_src_configure() {
	local mymesonargs=()

	if multilib_is_native_abi ; then
		mymesonargs+=(
			$(meson_use test tests)
		)
	fi

	meson_src_configure "${mymesonargs[@]}"
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
