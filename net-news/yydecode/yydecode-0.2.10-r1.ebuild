# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/yydecode/yydecode-0.2.10-r1.ebuild,v 1.5 2013/03/01 14:01:30 ago Exp $

EAPI=5

DESCRIPTION="A decoder for yENC format, popular on Usenet"
HOMEPAGE="http://yydecode.sourceforge.net/"
SRC_URI="mirror://sourceforge/yydecode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~ppc ~sparc x86"
IUSE=""

src_prepare() {
	sed -e "s/t3.sh//" -e "s/t7.sh//" -i checks/Makefile.in || die
}
