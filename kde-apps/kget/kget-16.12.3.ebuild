# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Advanced download manager by KDE"
HOMEPAGE="https://www.kde.org/applications/internet/kget/"
KEYWORDS="amd64 ~arm x86"
IUSE="debug bittorrent mms sqlite"

RDEPEND="
	app-crypt/qca:2[qt4]
	bittorrent? ( >=net-libs/libktorrent-1.0.3:4 )
	mms? ( media-libs/libmms )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

src_configure() {
	local mycmakeargs=(
		-DWITH_KDE4Workspace=OFF
		-DWITH_NepomukCore=OFF
		-DWITH_NepomukWidgets=OFF
		-DWITH_QGpgme=OFF
		-DWITH_KTorrent=$(usex bittorrent)
		-DWITH_LibMms=$(usex mms)
		-DWITH_Sqlite=$(usex sqlite)
	)

	kde4-base_src_configure
}
