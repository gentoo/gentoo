# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

COMMIT="fadcbdedb65998925482b26c88964b4213b9e1ac"
DESCRIPTION="Transport Independent RPC library for nfs-ganesha"
HOMEPAGE="https://github.com/linuxbox2/ntirpc"
SRC_URI="${HOMEPAGE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gssapi rdma"

# Since the GSS option only controls some extra files to be enabled,
# there's nothing to list in the depend string for it.
RDEPEND="app-crypt/mit-krb5
	rdma? ( sys-fabric/librdmacm )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

multilib_src_configure() {
	local mycmakeargs=(
		-DUSE_GSS="$(usex gssapi)"
		-DUSE_PRC_RDMA="$(usex rdma)"
	)
	cmake-utils_src_configure
}
