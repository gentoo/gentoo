# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/iconbox/iconbox-0.2.ebuild,v 1.8 2012/05/17 14:23:19 ssuominen Exp $

EAPI=4

MY_P=${P/-/_}

DESCRIPTION="App for placing icons in a menu which auto-hides"
HOMEPAGE="http://packages.gentoo.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-perl/gtk2-perl"
DEPEND="${RDEPEND}"

src_compile() { :; }

src_install() {
	dobin iconbox{,conf}
	dodoc Changelog README
	doman *.1
}
