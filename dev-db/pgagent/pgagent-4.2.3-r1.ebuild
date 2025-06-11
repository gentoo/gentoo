# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD=1
inherit cmake

DESCRIPTION="pgAgent is a job scheduler for PostgreSQL"
HOMEPAGE="https://www.pgadmin.org/download/pgagent-source-code/"
SRC_URI="https://github.com/pgadmin-org/${PN}/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="POSTGRESQL GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-user/pgagent
	dev-db/postgresql:*
	dev-libs/boost:=[icu]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.3-cmake-4.patch
)

src_prepare() {
	cmake_src_prepare

	sed -e "s:share):share/${P}):" \
		-i CMakeLists.txt || die "failed to patch CMakeLists.txt"
}

src_configure() {
	local mycmakeargs=( "-DSTATIC_BUILD:BOOLEAN=FALSE" )
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}/pgagent.initd-r1" "${PN}"
	newconfd "${FILESDIR}/pgagent.confd" "${PN}"

	rm "${ED}"/usr/{LICENSE,README} || die "failed to remove useless docs"
}
