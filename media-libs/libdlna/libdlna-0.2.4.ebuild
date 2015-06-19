# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdlna/libdlna-0.2.4.ebuild,v 1.8 2015/03/13 20:08:38 hwoarang Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="A reference open-source implementation of DLNA (Digital Living Network Alliance) standards"
HOMEPAGE="http://libdlna.geexbox.org"
SRC_URI="http://libdlna.geexbox.org/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"

DEPEND=">=virtual/ffmpeg-0.6.90"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libav9.patch
	# 540150
	epatch "${FILESDIR}"/${P}-ffmpeg.patch

	tc-export CC
}

src_configure() {
	# I can't use econf
	# --host is not implemented in ./configure file
	./configure \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--disable-static \
		|| die
}

src_compile() {
	# not parallel safe, error "cannot find -ldlna"
	emake -j1
}
