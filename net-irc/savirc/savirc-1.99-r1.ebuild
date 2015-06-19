# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/savirc/savirc-1.99-r1.ebuild,v 1.4 2015/03/28 21:36:35 ago Exp $

EAPI=5

DESCRIPTION="User friendly IRC client with unicode support and tcl/tk scripting"
SRC_URI="http://www.savirc.com/Downloads/savirc-Lin/${P}.tar.bz2"
HOMEPAGE="http://www.savirc.com/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	>=dev-lang/tcl-8.3.0:0=
	>=dev-lang/tk-8.3.0:0="
DEPEND=""
