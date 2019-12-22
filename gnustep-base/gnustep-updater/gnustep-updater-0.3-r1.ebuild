# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Helper tool to upgrade Gentoo GNUstep installations"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:GNUstep"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="app-misc/pax-utils
	>=gnustep-base/gnustep-make-2.6.0"
DEPEND="${RDEPEND}"

src_install() {
	dosbin gnustep-updater
	doman gnustep-updater.1
}
