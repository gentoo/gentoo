# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_P=${PN^}2-${PV}

DESCRIPTION="Modern C++ header-only framework for unit-tests"
HOMEPAGE="https://github.com/catchorg/Catch2"
SRC_URI="https://github.com/catchorg/Catch2/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

S=${WORKDIR}/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DNO_SELFTEST=$(usex !test)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc -r docs/.
}
