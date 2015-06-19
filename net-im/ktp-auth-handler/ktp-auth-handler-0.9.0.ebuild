# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ktp-auth-handler/ktp-auth-handler-0.9.0.ebuild,v 1.3 2015/02/22 18:41:23 mgorny Exp $

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el es et fi fr ga gl hu ia it ja kk km
ko lt mr nb nds nl pl pt pt_BR ro ru sk sl sr sr@ijekavian sr@ijekavianlatin
sr@latin sv uk vi zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDE Telepathy authentication handler"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="LGPL-2.1"
SLOT="4"
IUSE="debug"

DEPEND="
	app-crypt/qca:2[qt4(+)]
	>=dev-libs/qjson-0.8
	>=net-im/ktp-common-internals-${PV}
	>=net-libs/telepathy-qt-0.9.5[qt4]
"
RDEPEND="${DEPEND}
	app-crypt/qca:2[openssl]
"
