# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="ZeroMQ 'highlevel' C++ bindings"
HOMEPAGE="https://github.com/zeromq/zmqpp"
if [[ $PV == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zeromq/zmqpp.git"
else
	SRC_URI="https://github.com/zeromq/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

KEYWORDS="~amd64 ~x86"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="static-libs"

DEPEND="net-libs/zeromq[static-libs?]"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DIS_TRAVIS_CI_BUILD=OFF
		-DZMQPP_BUILD_SHARED=ON
		$(cmake-utils_use static-libs ZMQPP_BUILD_STATIC)
	)

	cmake-utils_src_configure
}
