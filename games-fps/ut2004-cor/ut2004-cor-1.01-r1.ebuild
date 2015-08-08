# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="Shape-shifting robot teamplay mod"
MOD_NAME="Counter Organic Revolution"
MOD_DIR="COR"

inherit games games-mods

HOMEPAGE="http://www.corproject.com/"
SRC_URI="http://168.158.223.115/COR_Beta_v1.0.zip
	http://168.158.223.115/COR_Patch_B1.0_to_B${PV}.zip"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"

src_unpack() {
	unpack COR_Beta_v1.0.zip COR_Patch_B1.0_to_B${PV}.zip
}

src_prepare() {
	rm -f ${MOD_DIR}/*.bat
}
