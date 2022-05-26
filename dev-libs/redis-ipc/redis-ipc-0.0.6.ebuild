# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A (redis) client library for using redis as system IPC msg/event bus"
HOMEPAGE="https://github.com/VCTLabs/redis-ipc"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/VCTLabs/redis-ipc.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0/1"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/hiredis:=
	dev-libs/json-c
"
RDEPEND="${DEPEND}
	dev-db/redis
"

src_prepare() {
	sed -i -e "s|/lib|/$(get_libdir)|" "${S}"/redis-ipc.pc.in || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DRIPC_BUILD_TESTING=$(usex test)
		-DRIPC_DISABLE_SOCK_TESTS=$(usex test)
	)

	cmake_src_configure
}
