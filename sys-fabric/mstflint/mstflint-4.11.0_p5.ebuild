# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Mstflint - an open source version of MFT (Mellanox Firmware Tools)"
HOMEPAGE="https://github.com/Mellanox/mstflint"
LICENSE="|| ( GPL-2 BSD-2 )"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="840c9c2193fe9145ab177b6e891fd535e1881b43"
MY_PV=${PV/_p/-}
MY_P=""
SRC_URI="${HOMEPAGE}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
IUSE="inband ssl"
SLOT="0"
RDEPEND="dev-db/sqlite:3=
	sys-libs/zlib:=
	inband? ( sys-fabric/libibmad )
	ssl? ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	echo '#define TOOLS_GIT_SHA "'${EGIT_COMMIT}'"' > ./common/gitversion.h || die
}

src_configure() {
	eautoreconf
	econf $(use_enable inband) $(use_enable ssl openssl)
	# /usr/bin/install: cannot create regular file '/var/tmp/portage/.../dev_mgt.py': File exists
	sed -e 's:^dev_mgt_pylib_DATA = c_dev_mgt.so dev_mgt.py:dev_mgt_pylib_DATA = c_dev_mgt.so:' -i dev_mgt/Makefile || die
}
