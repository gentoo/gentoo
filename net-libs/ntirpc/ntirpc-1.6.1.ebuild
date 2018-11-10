# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-multilib

DESCRIPTION="Transport Independent RPC library for nfs-ganesha"
HOMEPAGE="https://github.com/nfs-ganesha/ntirpc"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gssapi rdma"

# Since the GSS option only controls some extra files to be enabled,
# there's nothing to list in the depend string for it.
RDEPEND="app-crypt/mit-krb5
	net-libs/libnsl
	rdma? ( sys-fabric/librdmacm )"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DUSE_GSS="$(usex gssapi)"
		-DUSE_RPC_RDMA="$(usex rdma)"
	)
	cmake-utils_src_configure
}
