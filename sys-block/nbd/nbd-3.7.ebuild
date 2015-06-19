# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/nbd/nbd-3.7.ebuild,v 1.1 2014/01/21 22:49:20 vapier Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Userland client/server for kernel network block device"
HOMEPAGE="http://nbd.sourceforge.net/"
SRC_URI="mirror://sourceforge/nbd/${P}.tar.xz"

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
