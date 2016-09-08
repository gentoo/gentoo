# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="bs ca ca@valencia cs da de el es et fi fr ga gl hu ia it ja kk km
ko lt mr nb nds nl pl pt pt_BR ro ru sk sl sr sr@ijekavian sr@ijekavianlatin
sr@latin sv tr ug uk vi wa zh_CN zh_TW"
WEBKIT_REQUIRED="always"
inherit kde4-base

DESCRIPTION="KDE Telepathy text chat window"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"
SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="4"
IUSE="debug semantic-desktop"

DEPEND="
	dev-libs/qjson[qt4(+)]
	>=net-libs/telepathy-qt-0.9.5[qt4]
	>=net-libs/telepathy-logger-qt-0.8:0
	semantic-desktop? (
		$(add_kdeapps_dep kdepimlibs)
		>=net-libs/libkpeople-0.3.0:=
	)
"
RDEPEND="${DEPEND}
	>=kde-apps/ktp-contact-list-${PV}:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package semantic-desktop KPeople)
	)

	kde4-base_src_configure
}
