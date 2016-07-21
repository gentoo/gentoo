# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="POP3 mailbox deleter using regular expressions to match message headers and delete messages"
HOMEPAGE="http://www.topfx.com"
SRC_URI="http://www.topfx.com/dist/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	dev-perl/Curses-UI
	virtual/perl-Getopt-Long"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv popick.pl popick || die "Renaming popick.pl to popick"
	sed -i -e 's:/usr/local:/usr:g' $(grep -rl /usr/local *) || die "sed /usr/local failed"
}

src_compile() {
	# No compiling needed :)
	pod2man popick > popick.1 || die "Generating manpage failed"
}

src_install() {
	dobin popick
	doman popick.1
}
