# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
inherit cmake-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/catchorg/Catch2.git"
else
	MY_P=${PN^}2-${PV}
	SRC_URI="https://github.com/catchorg/Catch2/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"

	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="Modern C++ header-only framework for unit-tests"
HOMEPAGE="https://github.com/catchorg/Catch2"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DCATCH_ENABLE_WERROR=OFF
		-DBUILD_TESTING=$(usex test)
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)
	cmake-utils_src_configure
}
