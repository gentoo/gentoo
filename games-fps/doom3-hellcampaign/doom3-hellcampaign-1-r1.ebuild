# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MOD_DESC="map pack for Doom 3"
MOD_NAME="Hell Campaign"
MOD_DIR="hell_campaign"

inherit games games-mods

HOMEPAGE="http://www.gamefront.com/files/listing/gamingfiles/Doom_III/Maps/Map_Packs/"
SRC_URI="sp_hc_final.zip
	hardcorehellcampaign_patch.zip"

LICENSE="GameFront"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch bindist"

pkg_nofetch() {
	elog "Please download the following files:"
	elog "http://www.filefront.com/4445166"
	elog "http://www.filefront.com/4593578"
	elog "and move them to ${DISTDIR}"
}

src_unpack() {
	mkdir ${MOD_DIR}
	cd ${MOD_DIR}
	unpack ${A}
}

src_prepare() {
	cd ${MOD_DIR}

	# Prevent "non-portable" upper-case-filename warnings in Doom 3
	mv -f "Hardcore Hell Campaign.pk4" hardcore_hell_campaign.pk4 || die
	mv -f Q2Textures.pk4 q2Textures.pk4 || die
	mv -f Q3Textures.pk4 q3Textures.pk4 || die

	mv -f "Hardcore Hell Campaign.rtf" readme.rtf || die

	# Show nice description in "mods" menu within Doom 3
	echo "${MOD_NAME}" > description.txt
}
