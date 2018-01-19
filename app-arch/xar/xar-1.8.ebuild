# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic ltprune

APPLE_PV=400
DESCRIPTION="An easily extensible archive format"
HOMEPAGE="https://opensource.apple.com/source/xar/"
SRC_URI="https://opensource.apple.com/tarballs/xar/xar-${APPLE_PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="libressl kernel_Darwin"

DEPEND="
	!kernel_Darwin? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	app-arch/bzip2
	sys-libs/zlib
	dev-libs/libxml2
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.6.1-ext2.patch )

S=${WORKDIR}/${PN}-${APPLE_PV}/${PN}

src_prepare() {
	default
	sed -i -e 's/safe_dirname/xar_safe_dirname/' lib/linuxattr.c || die
}

src_configure() {
	use kernel_Darwin || append-libs $(pkg-config --libs openssl)
	econf \
		--disable-static
}

src_install() {
	default
	prune_libtool_files
}
