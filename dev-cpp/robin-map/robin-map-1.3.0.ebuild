# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ fast hash map and hash set using robin hood hashing"
HOMEPAGE="https://github.com/Tessil/robin-map"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Tessil/robin-map"
else
	SRC_URI="https://github.com/Tessil/robin-map/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-libs/boost )
"

src_test() {
	cd tests || die
	sed -i \
		-e '/Boost_USE_STATIC_LIBS/d' \
		-e 's/-Werror//' \
		CMakeLists.txt || die
	cmake -S "${S}/tests" -B . -GNinja || die
	eninja
	./tsl_robin_map_tests || die
}
