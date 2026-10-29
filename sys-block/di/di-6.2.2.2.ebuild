# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Disk Information Utility"
HOMEPAGE="https://diskinfo-di.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/diskinfo-di/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="rpc"

BDEPEND="sys-devel/gettext"
RDEPEND="rpc? ( sys-fs/quota[rpc] net-libs/libtirpc:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.2.2.2-gqr_status.patch
)

src_test() {
	local -x LD_LIBRARY_PATH="${BUILD_DIR}"
	cmake_build ditest
}
