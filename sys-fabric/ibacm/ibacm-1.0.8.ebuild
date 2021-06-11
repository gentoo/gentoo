# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit autotools openib

DESCRIPTION="IB CM pre-connection service application"
KEYWORDS="amd64 x86 ~amd64-linux"

RDEPEND="
	sys-fabric/libibumad:${SLOT}
	sys-fabric/libibverbs:${SLOT}
"
DEPEND="${RDEPEND}"

block_other_ofed_versions

PATCHES=(
	"${FILESDIR}"/${P}-fix-pthread-linkage.patch
)

src_prepare() {
	default

	# Needed for pthread fix (bug #611778)
	eautoreconf
}
