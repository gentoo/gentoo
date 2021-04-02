# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zeromq/zmqpp.git"
else
	SRC_URI="https://github.com/zeromq/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils

DESCRIPTION="ZeroMQ 'highlevel' C++ bindings"
HOMEPAGE="https://github.com/zeromq/zmqpp"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="static-libs"

DEPEND="net-libs/zeromq[static-libs?]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-multilib-strict.patch" )

src_configure() {
	local mycmakeargs=(
		-DIS_TRAVIS_CI_BUILD=OFF
		-DZMQPP_BUILD_SHARED=ON
		-DZMQPP_BUILD_STATIC=$(usex static-libs)
	)

	cmake-utils_src_configure
}
