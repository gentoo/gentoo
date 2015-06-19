# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/rote/rote-0.2.8.ebuild,v 1.4 2012/10/23 17:18:52 mr_bones_ Exp $

EAPI=4

DESCRIPTION="simple C library for VT102 terminal emulation"
HOMEPAGE="http://rote.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"
