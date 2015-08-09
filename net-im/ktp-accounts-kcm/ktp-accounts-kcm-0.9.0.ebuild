# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el en_GB eo es et fi fr ga gl hu ia it
ja kk km ko lt mai mr nb nds nl pa pl pt pt_BR ro ru sk sl sr sr@ijekavian
sr@ijekavianlatin sr@latin sv tr ug uk vi wa zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDE Telepathy account management kcm"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="LGPL-2.1"
SLOT="4"
IUSE="debug modemmanager"

DEPEND="
	>=net-im/ktp-common-internals-${PV}
	net-im/telepathy-mission-control
	net-libs/telepathy-glib
	>=net-libs/telepathy-qt-0.9.5[qt4]
	modemmanager? ( net-libs/libmm-qt )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build modemmanager pintxo)
	)

	kde4-base_src_configure
}
