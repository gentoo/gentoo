# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Rule management for SNORT"
SRC_URI="mirror://sourceforge/oinkmaster/${P}.tar.gz"
HOMEPAGE="http://oinkmaster.sf.net/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc sparc x86"
IUSE="X"

RDEPEND="
	>=dev-lang/perl-5.6.1
	X? ( dev-perl/Tk )
	net-misc/wget
	app-arch/tar
	app-arch/gzip
"

src_install() {
	dobin \
		contrib/addmsg.pl \
		contrib/addsid.pl \
		contrib/create-sidmap.pl \
		contrib/makesidex.pl \
		oinkmaster.pl

	use X && dobin contrib/oinkgui.pl

	dodoc FAQ README README.gui README.win32 UPGRADING contrib/README.contrib

	doman oinkmaster.1

	insinto /etc
	doins oinkmaster.conf
}
