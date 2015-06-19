# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/squashfuse/squashfuse-0.1_p20130530.ebuild,v 1.2 2013/06/14 09:20:10 zmedico Exp $

EAPI=5
inherit autotools

DESCRIPTION="FUSE filesystem to mount squashfs archives"
HOMEPAGE="https://github.com/vasi/squashfuse"
EGIT_COMMIT="f03158f49cb4adbb6459cb2a1898e586b488cb10"
SRC_URI="https://github.com/vasi/squashfuse/archive/${EGIT_COMMIT}.zip -> ${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="lzma lzo +zlib"
REQUIRED_USE="|| ( lzma zlib lzo )"

COMMON_DEPEND="
	>=sys-fs/fuse-2.8.6:=
	lzma? ( >=app-arch/xz-utils-5.0.4:= )
	zlib? ( >=sys-libs/zlib-1.2.5-r2:= )
	lzo? ( >=dev-libs/lzo-2.06:= )
"
DEPEND="app-arch/unzip
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
S=${WORKDIR}

src_unpack() {
	default
	mv ${PN}-${EGIT_COMMIT}/* ./ || die
}

src_prepare() {
	sed -i -e "1s:\\[0\\.1\\]:[${PV}]:" configure.ac || die
	AT_M4DIR=${S}/m4 eautoreconf
}

src_configure() {
	econf \
		$(use lzma || echo  --without-xz) \
		$(use lzo || echo --without-lzo) \
		$(use zlib || echo --without-zlib)
}
