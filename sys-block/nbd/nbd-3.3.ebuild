# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/nbd/nbd-3.3.ebuild,v 1.1 2013/04/22 21:42:17 radhermit Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Userland client/server for kernel network block device"
HOMEPAGE="http://nbd.sourceforge.net/"
SRC_URI="mirror://sourceforge/nbd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug zlib"

RDEPEND=">=dev-libs/glib-2.0
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

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
