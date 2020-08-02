# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="C++11 library to encode/decode base64, base64url, base32, base32hex and hex"
HOMEPAGE="https://github.com/tplgy/cppcodec"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tplgy/cppcodec.git"

	# Disable pulling in catch
	EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/tplgy/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( >=dev-cpp/catch-2.3.0:0 )"
BDEPEND="test? ( virtual/pkgconfig )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}
