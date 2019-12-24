# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/-/_}

DESCRIPTION="App for placing icons in a menu which auto-hides"
HOMEPAGE="https://packages.gentoo.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="
	dev-lang/perl
	dev-perl/Gtk2
	x11-libs/gtk+:2"

src_compile() { :; }

src_install() {
	dobin iconbox{,conf}

	einstalldocs
	doman *.1
}
