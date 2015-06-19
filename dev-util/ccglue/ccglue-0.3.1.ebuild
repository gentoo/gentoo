# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ccglue/ccglue-0.3.1.ebuild,v 1.3 2012/05/04 17:51:44 jdhore Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Produce cross-reference files from cscope and ctags for use with app-vim/cctree"
HOMEPAGE="http://ccglue.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-release-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/release-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
	eautoreconf
}
