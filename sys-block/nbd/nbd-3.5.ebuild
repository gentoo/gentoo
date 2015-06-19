# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/nbd/nbd-3.5.ebuild,v 1.6 2013/12/07 19:51:27 ago Exp $

EAPI="4"

inherit toolchain-funcs eutils

DESCRIPTION="Userland client/server for kernel network block device"
HOMEPAGE="http://nbd.sourceforge.net/"
SRC_URI="mirror://sourceforge/nbd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ppc64 ~sparc x86"
IUSE="debug zlib"

RDEPEND=">=dev-libs/glib-2.0
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gznbd-printf-u64.patch
	epatch "${FILESDIR}"/${P}-gznbd-zlib.patch
}

src_configure() {
	econf \
		--enable-lfs \
		--enable-syslog \
		$(use_enable debug)
}

src_compile() {
	default
	use zlib && emake -C gznbd CC="$(tc-getCC)"
}

src_install() {
	default
	use zlib && dobin gznbd/gznbd
}
