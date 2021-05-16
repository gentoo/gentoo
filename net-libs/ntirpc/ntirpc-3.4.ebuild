# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Transport Independent RPC library for nfs-ganesha"
HOMEPAGE="https://github.com/nfs-ganesha/ntirpc"
SRC_URI="https://github.com/nfs-ganesha/ntirpc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gssapi rdma"

# Since the GSS option only controls some extra files to be enabled,
# there's nothing to list in the depend string for it.
RDEPEND="
	dev-libs/userspace-rcu
	rdma? ( sys-fabric/librdmacm )
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	local mycmakeargs=(
		-DUSE_GSS="$(usex gssapi)"
		-DUSE_RPC_RDMA="$(usex rdma)"
	)
	cmake_src_configure
}
