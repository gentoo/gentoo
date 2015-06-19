# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmpasman/wmpasman-0.8.5.3.ebuild,v 1.2 2014/04/07 19:38:55 ssuominen Exp $

EAPI=5

DESCRIPTION="Password storage/retrieval in a dockapp"
HOMEPAGE="http://sourceforge.net/projects/wmpasman/"
SRC_URI="mirror://sourceforge/wmpasman/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4.1:2
	>=app-crypt/mhash-0.9.1
	>=app-crypt/mcrypt-2.6.4"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	virtual/pkgconfig
	>=x11-libs/libXpm-3.5.5"

DOCS="BUGS ChangeLog README TODO WARNINGS"
