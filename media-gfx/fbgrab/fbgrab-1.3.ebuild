# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fbgrab/fbgrab-1.3.ebuild,v 1.1 2015/06/28 18:58:12 zlogene Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Framebuffer screenshot utility"
HOMEPAGE="http://fbgrab.monells.se/"
SRC_URI="http://fbgrab.monells.se/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

RDEPEND="media-libs/libpng:=
	 sys-libs/zlib"

DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s:-g::" Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	newman ${PN}.1.man ${PN}.1
}
