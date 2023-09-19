# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/catchorg/Catch2.git"
	EGIT_BRANCH="Catch1.x"
else
	MY_P=${PN^}-${PV}
	SRC_URI="https://github.com/catchorg/Catch2/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"

	S="${WORKDIR}/${PN^}2-${PV}"
fi

DESCRIPTION="Modern C++ header-only framework for unit-tests"
HOMEPAGE="https://github.com/catchorg/Catch2"

LICENSE="Boost-1.0"
SLOT="1"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.2-glibc-2.34-sigstksz.patch
)

src_configure() {
	local mycmakeargs=(
		-DNO_SELFTEST=$(usex !test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc -r docs/.
}
