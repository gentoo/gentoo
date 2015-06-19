# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-updater/gnustep-updater-0.3.ebuild,v 1.4 2012/09/27 08:09:10 blueness Exp $

EAPI=4

DESCRIPTION="Helper tool to upgrade Gentoo GNUstep installations"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}
	app-misc/pax-utils
	>=gnustep-base/gnustep-make-2.6.0"

src_install() {
	dosbin gnustep-updater
	doman gnustep-updater.1
}
