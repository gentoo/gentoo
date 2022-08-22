# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for the KDE Release Service collection"
HOMEPAGE="https://kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="accessibility +admin +education +games +graphics +multimedia +network pim sdk +utils"

RDEPEND="
	>=kde-apps/kdecore-meta-${PV}:${SLOT}
	accessibility? ( >=kde-apps/kdeaccessibility-meta-${PV}:${SLOT} )
	admin? ( >=kde-apps/kdeadmin-meta-${PV}:${SLOT} )
	education? ( >=kde-apps/kdeedu-meta-${PV}:${SLOT} )
	games? ( >=kde-apps/kdegames-meta-${PV}:${SLOT} )
	graphics? ( >=kde-apps/kdegraphics-meta-${PV}:${SLOT} )
	multimedia? ( >=kde-apps/kdemultimedia-meta-${PV}:${SLOT} )
	network? ( >=kde-apps/kdenetwork-meta-${PV}:${SLOT} )
	pim? ( >=kde-apps/kdepim-meta-${PV}:${SLOT} )
	sdk? ( >=kde-apps/kdesdk-meta-${PV}:${SLOT} )
	utils? ( >=kde-apps/kdeutils-meta-${PV}:${SLOT} )
"
