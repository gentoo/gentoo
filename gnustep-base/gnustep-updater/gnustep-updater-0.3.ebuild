# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Helper tool to upgrade Gentoo GNUstep installations"
HOMEPAGE="https://www.gentoo.org"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.bz2"

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
