# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="vilearn is an interactive vi tutorial comprised of 5 tutorials for the vi-impaired"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="app-editors/vim"

src_prepare() {
	sed -i "s:/usr/local:${EPREFIX}/usr:" Makefile
}

src_install() {
	dobin vilearn
	doman vilearn.1
	dodoc README outline

	insinto /usr/lib/vilearn
	doins [0-9]*
}
