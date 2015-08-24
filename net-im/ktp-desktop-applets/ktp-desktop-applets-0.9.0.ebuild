# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el es et fi fr ga gl hu ia it ja kk km
ko lt mr nb nds nl pl pt pt_BR ro ru sk sl sr sr@ijekavian sr@ijekavianlatin
sr@latin sv tr uk vi wa zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDE Telepathy contact, presence and chat Plasma applets"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="4"
IUSE="debug"

DEPEND="
	>=net-im/ktp-common-internals-${PV}
	>=net-libs/telepathy-qt-0.9.5[qt4]
"
RDEPEND="${DEPEND}
	>=net-im/ktp-contact-list-${PV}
"
