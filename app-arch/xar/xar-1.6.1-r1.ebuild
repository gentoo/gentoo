# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune

DESCRIPTION="An easily extensible archive format"
HOMEPAGE="https://github.com/mackyle/xar"
SRC_URI="mirror://github/mackyle/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+bzip2 libressl"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	bzip2? ( app-arch/bzip2	)
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-ext2.patch )

src_prepare() {
	default
	eautoconf
}

src_configure() {
	econf \
		$(use_with bzip2) \
		--disable-static
}

src_install() {
	default
	prune_libtool_files
}
