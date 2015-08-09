# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el es et fi fr ga gl hu ia it ja kk km
ko lt mr nb nds nl pl pt pt_BR ro ru sk sl sr sr@ijekavian sr@ijekavianlatin
sr@latin sv tr ug uk vi wa zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDE Telepathy text chat window"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="4"
IUSE="debug semantic-desktop"

DEPEND="
	dev-libs/qjson[qt4(+)]
	>=net-libs/telepathy-qt-0.9.5[qt4]
	>=net-libs/telepathy-logger-qt-0.8:0
	semantic-desktop? (
		$(add_kdebase_dep kdepimlibs)
		>=net-libs/libkpeople-0.3.0:=
	)
"
RDEPEND="${DEPEND}
	>=net-im/ktp-contact-list-${PV}
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package semantic-desktop KPeople)
	)

	kde4-base_src_configure
}
