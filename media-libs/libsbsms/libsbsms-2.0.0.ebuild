# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsbsms/libsbsms-2.0.0.ebuild,v 1.3 2015/01/29 17:41:44 mgorny Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="A library for high quality time and pitch scale modification"
HOMEPAGE="http://sbsms.sourceforge.net/"
SRC_URI="mirror://sourceforge/sbsms/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_sse sse) \
		--disable-multithreaded
		# threaded version causes segfaults
}

src_install() {
	default
	prune_libtool_files
}
