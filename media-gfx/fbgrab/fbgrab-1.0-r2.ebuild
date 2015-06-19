# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fbgrab/fbgrab-1.0-r2.ebuild,v 1.6 2013/06/27 22:15:29 zlogene Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Framebuffer screenshot utility"
HOMEPAGE="http://hem.bredband.net/gmogmo/fbgrab/"
SRC_URI="http://hem.bredband.net/gmogmo/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND="media-libs/libpng
	 sys-libs/zlib"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-zlib_h.patch" \
	       "${FILESDIR}/${P}-Makefile.patch"

		epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	newman ${PN}.1.man ${PN}.1
}
