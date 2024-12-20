# Copyright 2015-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake-multilib

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/nemtrif/utfcpp"
	EGIT_SUBMODULES=()
else
	inherit unpacker

	FTEST_GIT_REVISION="1e14b77c2ab8489386fc7046a8bced696c0fc4d6"
	FTEST_DATE="20211106174116"
fi

DESCRIPTION="UTF-8 C++ library"
HOMEPAGE="https://github.com/nemtrif/utfcpp"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/nemtrif/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		test? ( https://github.com/nemtrif/ftest/archive/${FTEST_GIT_REVISION}.tar.gz -> ftest-${FTEST_DATE}.tar.gz )"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="Boost-1.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_unpack() {
	default
	multilib_parallel_foreach_abi multilib_src_unpack
	if [[ "${PV}" == "9999" ]] && use test; then
		git-r3_fetch https://github.com/nemtrif/ftest refs/heads/master
		git-r3_checkout https://github.com/nemtrif/ftest ftest
	else
		unpacker "${DISTDIR}"/ftest-${FTEST_DATE}.tar.gz
		use test && mv ftest-${FTEST_GIT_REVISION} ftest || die
	fi
	rm -r "${S}/extern/ftest" || die
	ln -s ../../ftest "${S}/extern/ftest" || die
}

multilib_src_unpack() {
	mkdir -p "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" || die
		if [[ "${PV}" == "9999" ]]; then
			git-r3_src_unpack
		else
			unpacker "${DISTDIR}"/${P}.tar.gz
		fi
	popd || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DUTF8_SAMPLES=OFF
		-DUTF8_TESTS=$(usex test ON OFF)
	)

	cmake_src_configure
}
