# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Advanced SAT solver with C++ and command-line interfaces"
HOMEPAGE="https://github.com/msoos/cryptominisat/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/msoos/${PN}.git"
else
	SRC_URI="https://github.com/msoos/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0/${PV}"
LICENSE="GPL-2 MIT"
RESTRICT="test"         # Tests require many git modules.

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

src_configure() {
	local -a mycmakeargs=(
		-DNOBREAKID=ON
		-DNOM4RI=ON
		-DENABLE_TESTING=OFF
	)
	cmake_src_configure
}
