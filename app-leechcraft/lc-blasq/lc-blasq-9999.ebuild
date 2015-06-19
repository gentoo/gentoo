# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-blasq/lc-blasq-9999.ebuild,v 1.2 2013/08/27 16:10:06 kensington Exp $

EAPI="5"

inherit leechcraft

DESCRIPTION="Cloud image storage services client (like Flickr or Picasa)"

SLOT="0"
KEYWORDS=""
IUSE="debug +deathnote +rappor +spegnersi +vangog"

DEPEND="~app-leechcraft/lc-core-${PV}
		deathnote? ( dev-qt/qtxmlpatterns:4 )
		spegnersi? ( dev-libs/kqoauth )
		vangog? ( dev-libs/qjson )
		"
RDEPEND="${DEPEND}"

src_configure(){
	local mycmakeargs=(
		$(cmake-utils_use_enable deathnote BLASQ_DEATHNOTE)
		$(cmake-utils_use_enable rappor BLASQ_RAPPOR)
		$(cmake-utils_use_enable spegnersi BLASQ_SPEGNERSI)
		$(cmake-utils_use_enable vangog BLASQ_VANGOG)
	)

	cmake-utils_src_configure
}
