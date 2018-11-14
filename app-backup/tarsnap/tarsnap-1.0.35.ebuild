# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Online backups for the truly paranoid"
HOMEPAGE="http://www.tarsnap.com/"
SRC_URI="https://www.tarsnap.com/download/${PN}-autoconf-${PV}.tgz"

LICENSE="tarsnap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl bzip2 libressl lzma cpu_flags_x86_sse2 xattr"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-libs/e2fsprogs-libs
	sys-libs/zlib
	acl? ( sys-apps/acl )
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}
	virtual/os-headers" # Required for "magic.h"

S=${WORKDIR}/${PN}-autoconf-${PV}

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable xattr) \
		$(use_enable acl) \
		$(use_with bzip2 bz2lib) \
		--without-lzmadec \
		$(use_with lzma)
}
