# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="bg bs ca ca@valencia cs da de el en_GB eo es et fi fr ga gl hu ia
it ja kk km ko lt mai mr nb nds nl pl pt pt_BR ro ru sk sl sr sr@ijekavian
sr@ijekavianlatin sr@latin sv th tr ug uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDE Telepathy audio/video conferencing ui"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"
SRC_URI="mirror://kde/stable/kde-telepathy/${PV}/src/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2 LGPL-2.1"
SLOT="4"
IUSE="debug v4l"

DEPEND="
	>=kde-apps/ktp-common-internals-${PV}:4
	>=media-libs/qt-gstreamer-1.2.0[qt4]
	net-libs/farstream:0.2
	>=net-libs/telepathy-farstream-0.6.0
	>=net-libs/telepathy-qt-0.9.5[farstream,qt4]
"
RDEPEND="${DEPEND}
	|| (
		>=kde-apps/ktp-contact-list-${PV}:4
		>=kde-apps/ktp-desktop-applets-${PV}:4
		>=kde-apps/ktp-text-ui-${PV}:4
	)
	v4l? ( media-plugins/gst-plugins-v4l2:0.10 )
"
