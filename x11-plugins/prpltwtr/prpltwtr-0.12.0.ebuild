# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/prpltwtr/prpltwtr-0.12.0.ebuild,v 1.1 2012/07/10 08:49:31 jdhore Exp $

EAPI=4

DESCRIPTION="libpurple twitter protocol"
HOMEPAGE="https://code.google.com/p/prpltwtr/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${RDEPEND}
		virtual/pkgconfig"
RDEPEND=">=net-im/pidgin-2.6"
