# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PV="$(ver_cut 1-2)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="oneAPI Level Zero headers, loader and validation layer"
HOMEPAGE="https://github.com/oneapi-src/level-zero"
SRC_URI="https://github.com/oneapi-src/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cmake_src_prepare
	# According to upstream, release tarballs should contain this file
	# - but at least some of them do not. Fortunately it is trivial
	# to make one ourselves.
	echo "$(ver_cut 3)" > "${S}"/VERSION_PATCH || die "Failed to seed the version file"
}
