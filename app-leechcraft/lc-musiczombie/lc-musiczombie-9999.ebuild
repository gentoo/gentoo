# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-musiczombie/lc-musiczombie-9999.ebuild,v 1.1 2013/03/08 22:02:51 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="MusicBrainz client plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug acoustid"

DEPEND="~app-leechcraft/lc-core-${PV}
	acoustid? ( media-libs/chromaprint )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_with acoustid MUSICZOMBIE_CHROMAPRINT)
	"
	cmake-utils_src_configure
}
