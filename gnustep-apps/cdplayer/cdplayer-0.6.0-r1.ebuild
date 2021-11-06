# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
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
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -e "s#cdda.h#paranoia/cdda.h#" \
		-e "s#paranoia.h#paranoia/paranoia.h#" \
		-i AudioCD/AudioCD.h || die
}

src_compile() {
	local myconf=""
	use dbus || myconf="${myconf} notifications=no"

	egnustep_env
	egnustep_make ${myconf}
}
