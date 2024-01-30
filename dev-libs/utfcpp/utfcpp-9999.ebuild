# Copyright 2015-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/nemtrif/utfcpp"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	FTEST_GIT_REVISION=""
	FTEST_DATE=""
	SRC_URI="https://github.com/nemtrif/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		test? ( https://github.com/nemtrif/ftest/archive/${FTEST_GIT_REVISION}.tar.gz -> ftest-${FTEST_DATE}.tar.gz )"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="UTF-8 C++ library"
HOMEPAGE="https://github.com/nemtrif/utfcpp"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack

		if use test; then
			git-r3_fetch https://github.com/nemtrif/ftest refs/heads/master
			git-r3_checkout https://github.com/nemtrif/ftest "${WORKDIR}/ftest"
		fi
	else
		default

		if use test; then
			mv ftest-${FTEST_GIT_REVISION} ftest || die
		fi
	fi

	rmdir "${S}/extern/ftest" || die
	ln -s ../../ftest "${S}/extern/ftest" || die
}

src_configure() {
	cmake_src_configure

	pushd tests > /dev/null || die
		cmake_src_configure
	popd > /dev/null || die
}

src_test() {
	pushd tests > /dev/null || die
		cmake_src_test
	popd > /dev/null || die
}
