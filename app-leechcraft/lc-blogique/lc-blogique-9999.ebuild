# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Blogging client for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug +metida +hestia"

DEPEND="
	~app-leechcraft/lc-core-${PV}
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5
	dev-qt/qtxml:5
	dev-qt/qtprintsupport:5
	dev-qt/qtdeclarative:5
	metida? (
		dev-qt/qtnetwork:5
		dev-qt/qtxmlpatterns:5
	)
"
RDEPEND="${DEPEND}
	virtual/leechcraft-wysiwyg-editor
	"

src_configure() {
	local mycmakeargs=(
		-DENABLE_BLOGIQUE_METIDA=$(usex metida)
		-DENABLE_BLOGIQUE_HESTIA=$(usex hestia)
	)

	cmake-utils_src_configure
}
