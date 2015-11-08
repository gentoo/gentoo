# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit leechcraft

DESCRIPTION="Blogging client for LeechCraft"

SLOT="0"
KEYWORDS=" amd64 ~x86"
IUSE="debug +metida +hestia"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtsql:4[sqlite]
	metida? ( dev-qt/qtxmlpatterns:4 )
	"
RDEPEND="${DEPEND}
	virtual/leechcraft-wysiwyg-editor
	"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable metida BLOGIQUE_METIDA)
		$(cmake-utils_use_enable hestia BLOGIQUE_HESTIA)
	)

	cmake-utils_src_configure
}
