# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A C++ implementation of a memory efficient hash map and hash set"
HOMEPAGE="https://github.com/Tessil/sparse-map"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Tessil/sparse-map"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/Tessil/sparse-map/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

src_configure() {
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
