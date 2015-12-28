# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs cs da de en_GB eo es et fi fr ga gl hu it ja km lt mai mr nds
nl pl pt pt_BR ru sk sv tr ug uk zh_CN"
inherit kde4-base

DESCRIPTION="KDE based CDDA extraction tool"
HOMEPAGE="https://userbase.kde.org/Audex"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkcddb)
	$(add_kdeapps_dep libkcompactdisc)
	media-sound/cdparanoia
"
RDEPEND="${DEPEND}"
