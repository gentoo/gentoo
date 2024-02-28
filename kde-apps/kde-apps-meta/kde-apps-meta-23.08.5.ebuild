# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for the KDE Release Service collection"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="accessibility +admin +education +games +graphics +multimedia +network pim sdk +utils"

RDEPEND="
	>=kde-apps/kdecore-meta-${PV}:0
	accessibility? ( >=kde-apps/kdeaccessibility-meta-${PV}:0 )
	admin? ( >=kde-apps/kdeadmin-meta-${PV}:0 )
	education? ( >=kde-apps/kdeedu-meta-${PV}:0 )
	games? ( >=kde-apps/kdegames-meta-${PV}:0 )
	graphics? ( >=kde-apps/kdegraphics-meta-${PV}:0 )
	multimedia? ( >=kde-apps/kdemultimedia-meta-${PV}:0 )
	network? ( >=kde-apps/kdenetwork-meta-${PV}:0 )
	pim? ( >=kde-apps/kdepim-meta-${PV}:0 )
	sdk? ( >=kde-apps/kdesdk-meta-${PV}:0 )
	utils? ( >=kde-apps/kdeutils-meta-${PV}:0 )
"
