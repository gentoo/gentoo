# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/nebula/nebula-0.5.ebuild,v 1.6 2012/11/18 13:12:03 ago Exp $

EAPI=4

DESCRIPTION="An IRC client for X11 and Motif"
HOMEPAGE="http://nebula-irc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}-irc/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=x11-libs/motif-2.3:0"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )
