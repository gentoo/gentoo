# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pax-utils

DESCRIPTION="The open source Windows Imaging (WIM) library"
HOMEPAGE="https://wimlib.net"
SRC_URI="https://wimlib.net/downloads/${P}.tar.gz"

LICENSE="|| ( GPL-3+ LGPL-3+ ) MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fuse iso ntfs test yasm"
RESTRICT="!test? ( test )"

RDEPEND="
	fuse? ( sys-fs/fuse:3 )
	iso? (
		app-arch/cabextract
		app-cdr/cdrtools
	)
	ntfs? ( sys-fs/ntfs3g:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with ntfs ntfs-3g)
		$(use_with fuse)
		$(use_enable test test-support)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	pax-mark m "${S}"/.libs/wimlib-imagex
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
