# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for the KDE Applications collection"
HOMEPAGE="https://kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="accessibility pim sdk"

RDEPEND="
	>=kde-apps/kdeadmin-meta-${PV}:${SLOT}
	>=kde-apps/kdecore-meta-${PV}:${SLOT}
	>=kde-apps/kdeedu-meta-${PV}:${SLOT}
	>=kde-apps/kdegames-meta-${PV}:${SLOT}
	>=kde-apps/kdegraphics-meta-${PV}:${SLOT}
	>=kde-apps/kdemultimedia-meta-${PV}:${SLOT}
	>=kde-apps/kdenetwork-meta-${PV}:${SLOT}
	>=kde-apps/kdeutils-meta-${PV}:${SLOT}
	accessibility? ( >=kde-apps/kdeaccessibility-meta-${PV}:${SLOT} )
	pim? ( >=kde-apps/kdepim-meta-${PV}:${SLOT} )
	sdk? ( >=kde-apps/kdesdk-meta-${PV}:${SLOT} )
"
