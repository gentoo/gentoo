# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit cmake-multilib

DESCRIPTION="Transport Independent RPC library for nfs-ganesha"
HOMEPAGE="https://github.com/linuxbox2/ntirpc"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gssapi rdma"

# Since the GSS option only controls some extra files to be enabled,
# there's nothing to list in the depend string for it.
RDEPEND="app-crypt/mit-krb5
	rdma? ( sys-fabric/librdmacm )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-city-header.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use gssapi GSS)
		$(cmake-utils_use_use rdma RPC_RDMA)
	)
	cmake-utils_src_configure
}
