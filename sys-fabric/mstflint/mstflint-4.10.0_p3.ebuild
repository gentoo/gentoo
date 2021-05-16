# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Mstflint - an open source version of MFT (Mellanox Firmware Tools)"
HOMEPAGE="https://github.com/Mellanox/mstflint"
LICENSE="|| ( GPL-2 BSD-2 )"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="941bf389b87686ca2be8d6a8fcf0b2ee22955ecc"
MY_PV=${PV/_p/-}
MY_P=""
SRC_URI="https://github.com/Mellanox/mstflint/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
IUSE="inband"
SLOT="0"
RDEPEND="inband? ( sys-fabric/libibmad )
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	echo '#define TOOLS_GIT_SHA "'${EGIT_COMMIT}'"' > ./common/gitversion.h || die
}

src_configure() {
	eautoreconf
	econf $(use_enable inband)
	# /usr/bin/install: cannot create regular file '/var/tmp/portage/.../dev_mgt.py': File exists
	sed -e 's:^dev_mgt_pylib_DATA = c_dev_mgt.so dev_mgt.py:dev_mgt_pylib_DATA = c_dev_mgt.so:' -i dev_mgt/Makefile || die
}
