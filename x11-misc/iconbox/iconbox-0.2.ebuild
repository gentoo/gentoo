# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

MY_P=${P/-/_}

DESCRIPTION="App for placing icons in a menu which auto-hides"
HOMEPAGE="https://packages.gentoo.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-perl/Gtk2"
DEPEND="${RDEPEND}"

src_compile() { :; }

src_install() {
	dobin iconbox{,conf}
	dodoc Changelog README
	doman *.1
}
