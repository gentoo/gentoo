# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="ar bg br bs cs cy da de el en_GB eo es et fi fr ga gl hr hu is it
ja ka km lt ms nb nds nl pl pt pt_BR ro ru rw sk sl sr sv tr ug uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="The KDE Network Monitor"
HOMEPAGE="http://kde-apps.org/content/show.php?content=12956"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/12956-${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug wifi"

DEPEND="
	dev-libs/libnl:3
	dev-qt/qtsql:4[sqlite]
	kde-plasma/ksysguard:4
	kde-plasma/systemsettings:4
	sys-apps/net-tools
	wifi? ( net-wireless/wireless-tools )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no wifi WIRELESS_SUPPORT)
	)

	kde4-base_src_configure
}
