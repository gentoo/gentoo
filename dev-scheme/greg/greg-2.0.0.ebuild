# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit autotools eutils

DESCRIPTION="Testing-Framework for guile"
HOMEPAGE="http://gna.org/projects/greg/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
LICENSE="GPL-2"
IUSE=""

RDEPEND=">=dev-scheme/guile-1.8"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PV}-notest.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS README AUTHORS ChangeLog || die
}
