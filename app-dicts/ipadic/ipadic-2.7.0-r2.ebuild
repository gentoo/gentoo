# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ipadic/ipadic-2.7.0-r2.ebuild,v 1.6 2015/03/02 09:32:50 ago Exp $

EAPI="4"
inherit autotools eutils

DESCRIPTION="Japanese dictionary for ChaSen"
HOMEPAGE="http://sourceforge.jp/projects/ipadic/"
SRC_URI="mirror://sourceforge.jp/${PN}/24435/${P}.tar.gz"

LICENSE="ipadic"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
IUSE=""

DEPEND=">=app-text/chasen-2.3.1"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${PF}-gentoo.patch"
	eautoreconf
}

src_install () {
	default

	insinto /etc
	doins chasenrc
	dodoc AUTHORS ChangeLog NEWS README
}
