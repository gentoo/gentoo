# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libaacs/libaacs-0.8.1.ebuild,v 1.1 2015/05/11 06:52:55 aballier Exp $

EAPI=5

inherit autotools-multilib

DESCRIPTION="Open implementation of the Advanced Access Content System (AACS) specification"
HOMEPAGE="http://www.videolan.org/developers/libaacs.html"
SRC_URI="ftp://ftp.videolan.org/pub/videolan/libaacs/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
	>=dev-libs/libgpg-error-1.12[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc"

DOCS=( ChangeLog KEYDB.cfg README.txt )

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		--disable-optimizations
	)
	autotools-multilib_src_configure
}
