# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="bs ca ca@valencia cs da de el es et fi fr ga gl hu ia it ja kk km
ko lt mr nb nds nl pl pt pt_BR ro ru sk sl sr sr@ijekavian sr@ijekavianlatin
sr@latin sv uk zh_CN zh_TW"
MY_P=${PN/kded/kded-integration}-${PV}
inherit kde4-base

DESCRIPTION="KDE Telepathy workspace integration"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"
SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${MY_P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="LGPL-2.1"
SLOT="4"
IUSE="debug"

DEPEND="
	>=kde-apps/ktp-common-internals-${PV}:4
	>=net-libs/telepathy-qt-0.9.5[qt4]
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
