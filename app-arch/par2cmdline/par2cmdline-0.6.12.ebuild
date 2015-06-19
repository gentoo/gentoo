# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/par2cmdline/par2cmdline-0.6.12.ebuild,v 1.2 2015/06/11 15:04:54 ago Exp $

EAPI=5
inherit autotools

DESCRIPTION="A PAR-2.0 file verification and repair tool"
HOMEPAGE="http://github.com/BlackIkeEagle/par2cmdline"
SRC_URI="http://github.com/BlackIkeEagle/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DOCS="AUTHORS ChangeLog README" # NEWS is empty, PORTING and ROADMAP are for building

src_prepare() {
	eautoreconf
}
