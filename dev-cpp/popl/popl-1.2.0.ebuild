# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Header-only C++ program options parser library"
HOMEPAGE="https://github.com/badaix/popl"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/badaix/popl.git"
	EGIT_BRANCH="develop"
else

	SRC_URI="https://github.com/badaix/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"

src_configure() {
	local mycmakeargs=( -DBUILD_EXAMPLE=OFF )

	cmake_src_configure
}
