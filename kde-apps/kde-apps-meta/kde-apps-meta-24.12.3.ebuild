# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for the KDE Release Service collection"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="accessibility +admin +education +games +graphics +multimedia +network pim sdk +utils"

RDEPEND="
	>=kde-apps/kdecore-meta-${PV}:*
	accessibility? ( >=kde-apps/kdeaccessibility-meta-${PV}:* )
	admin? ( >=kde-apps/kdeadmin-meta-${PV}:* )
	education? ( >=kde-apps/kdeedu-meta-${PV}:* )
	games? ( >=kde-apps/kdegames-meta-${PV}:* )
	graphics? ( >=kde-apps/kdegraphics-meta-${PV}:* )
	multimedia? ( >=kde-apps/kdemultimedia-meta-${PV}:* )
	network? ( >=kde-apps/kdenetwork-meta-${PV}:* )
	pim? ( >=kde-apps/kdepim-meta-${PV}:* )
	sdk? ( >=kde-apps/kdesdk-meta-${PV}:* )
	utils? ( >=kde-apps/kdeutils-meta-${PV}:* )
"
