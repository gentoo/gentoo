# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ktp-common-internals/ktp-common-internals-0.9.0.ebuild,v 1.2 2015/04/11 16:10:56 kensington Exp $

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el es et fi fr ga gl hu ia it ja kk ko
lt mr nb nds nl pl pt pt_BR ro ru sk sl sr sr@ijekavian sr@ijekavianlatin
sr@latin sv uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDE Telepathy common library"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="LGPL-2.1"
SLOT="4"
IUSE="debug otr semantic-desktop"

DEPEND="
	>=net-libs/telepathy-qt-0.9.5[qt4]
	>=net-libs/telepathy-logger-qt-0.5.80:0
	otr? (
		dev-libs/libgcrypt:=
		>=net-libs/libotr-4.0.0
	)
	semantic-desktop? (
		$(add_kdebase_dep kdepimlibs)
		>=net-libs/libkpeople-0.3.0:=
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package otr Libgcrypt)
		$(cmake-utils_use_find_package otr LibOTR)
		$(cmake-utils_use_find_package semantic-desktop KPeople)
		$(cmake-utils_use_find_package semantic-desktop KdepimLibs)
	)

	kde4-base_src_configure
}
