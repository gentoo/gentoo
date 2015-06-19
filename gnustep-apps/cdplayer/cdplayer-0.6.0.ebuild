# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/cdplayer/cdplayer-0.6.0.ebuild,v 1.1 2014/02/07 18:24:31 voyageur Exp $

EAPI=5
inherit gnustep-2

DESCRIPTION="Small CD Audio Player for GNUstep"
HOMEPAGE="https://github.com/schik/cdplayer"
SRC_URI="https://github.com/schik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="dbus"
DEPEND="dev-libs/libcdio
	dev-libs/libcdio-paranoia
	gnustep-apps/cynthiune
	dbus? ( gnustep-libs/dbuskit )"
RDEPEND="${DEPEND}
	!gnustep-libs/cddb"

src_prepare() {
	sed -e "s#cdda.h#paranoia/cdda.h#" \
		-e "s#paranoia.h#paranoia/paranoia.h#" \
		-i AudioCD/AudioCD.h || die "AudioCD.h sed failed"
}

src_compile() {
	local myconf=""
	use dbus || myconf="${myconf} notifications=no"

	egnustep_env
	egnustep_make ${myconf}
}
