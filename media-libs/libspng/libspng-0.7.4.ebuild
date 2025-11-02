# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Simple, modern libpng alternative"
HOMEPAGE="https://github.com/randy408/libspng"
SRC_URI="
	https://github.com/randy408/libspng/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
	test? (
		>=media-libs/libpng-1.6.0
	)
"

src_configure() {
	local emesonargs=(
		$(meson_use test dev_build)
	)

	meson_src_configure
}

src_test() {
	local -a tests
	tests=( $(meson test --list -C "${BUILD_DIR}") )

	local -a skip_tests=(
		# Incompatabilities with >=libpng-1.6.47
		# bug #956692
		ch1n3p04
		ch2n3p08
	)

	for test_index in ${!tests[@]}; do
		if [[ ${skip_tests[@]} =~ ${tests[${test_index}]} ]]; then
			unset tests[${test_index}]
		fi
	done

	meson_src_test ${tests[@]}
}
