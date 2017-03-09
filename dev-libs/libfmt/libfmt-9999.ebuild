# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Small, safe and fast formatting library"
HOMEPAGE="https://github.com/fmtlib/fmt"

LICENSE="BSD-2"
IUSE="test"
SLOT="0"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="git://github.com/fmtlib/fmt.git"
	inherit git-r3
else
	SRC_URI="https://github.com/fmtlib/fmt/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/fmt-${PV}"
fi

DEPEND=""
RDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DFMT_TEST=$(usex test)
		-DBUILD_SHARED_LIBS=ON
	)
	cmake-utils_src_configure
}
