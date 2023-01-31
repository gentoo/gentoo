# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="oneAPI Level Zero headers, loader and validation layer"
HOMEPAGE="https://github.com/oneapi-src/level-zero"
SRC_URI="https://github.com/oneapi-src/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"

src_prepare() {
	cmake_src_prepare

	# According to upstream, release tarballs should contain this file but at least
	# some of them do not. Fortunately it is trivial to make one ourselves.
	echo "$(ver_cut 3)" > "${S}"/VERSION_PATCH || die
}
