# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Dobiasd/FunctionalPlus.git"
else
	SRC_URI="https://github.com/Dobiasd/FunctionalPlus/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Functional Programming Library for C++"
HOMEPAGE="
	https://www.editgym.com/fplus-api-search/
	https://github.com/Dobiasd/FunctionalPlus
"

LICENSE="Boost-1.0"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/doctest )"

S="${WORKDIR}/FunctionalPlus-${PV}"

fplus_test_wrapper() {
	local BUILD_DIR="${WORKDIR}/${P}_build/test"
	local CMAKE_USE_DIR="${S}/test"
	$@
}

src_prepare() {
	# avoid -Werror, bug 926538
	sed -i 's/-Werror//' cmake/warnings.cmake || die
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
	use test && fplus_test_wrapper cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use test && fplus_test_wrapper cmake_src_compile
}

src_test() {
	fplus_test_wrapper cmake_src_test
}
