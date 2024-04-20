# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit autotools python-any-r1

DESCRIPTION="Basic data structures in C"
HOMEPAGE="https://github.com/msune/libcdada"
SRC_URI="https://github.com/msune/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
BDEPEND="test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.4-Werror.patch
	"${FILESDIR}"/${PN}-0.3.5-respect-CFLAGS.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with test tests)

		# Needed for tests. We throw them away in src_install anyway.
		--enable-static

		--disable-valgrind
		--without-examples
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
