# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MOD_DESC="Shape-shifting robot teamplay mod"
MOD_NAME="Counter Organic Revolution"
MOD_DIR="COR"

inherit games games-mods

HOMEPAGE="http://www.moddb.com/mods/counter-organic-revolution"
SRC_URI="https://ut.rushbase.net/beyondunreal/mods/cor_beta_v1.0.zip
	https://ut.rushbase.net/beyondunreal/mods/cor_patch_b1_to_b101.zip"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"

src_prepare() {
	rm -f ${MOD_DIR}/*.bat || die
}
