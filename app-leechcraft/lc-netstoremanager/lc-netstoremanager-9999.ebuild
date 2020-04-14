# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="LeechCraft plugin for supporting cloud data storages like Google Drive"

SLOT="0"
KEYWORDS=""
IUSE="+dropbox +googledrive"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_NETSTOREMANAGER_DROPBOX=$(usex dropbox)
		-DENABLE_NETSTOREMANAGER_GOOGLEDRIVE=$(usex googledrive)
	)

	cmake_src_configure
}
