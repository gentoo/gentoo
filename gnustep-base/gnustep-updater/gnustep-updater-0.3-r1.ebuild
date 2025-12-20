# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Helper tool to upgrade Gentoo GNUstep installations"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:GNUstep"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="app-misc/pax-utils
	>=gnustep-base/gnustep-make-2.6.0"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -e "s#/etc/init.d/functions.sh#/lib/gentoo/functions.sh#" \
		-i gnustep-updater || die
}

src_install() {
	dosbin gnustep-updater
	doman gnustep-updater.1
}
