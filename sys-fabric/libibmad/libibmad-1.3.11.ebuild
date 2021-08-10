# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB library provides the API for use interfacing with IB management programs"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE=""

DEPEND="
	sys-fabric/libibumad:${SLOT}
	"
RDEPEND="${DEPEND}"
block_other_ofed_versions

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
