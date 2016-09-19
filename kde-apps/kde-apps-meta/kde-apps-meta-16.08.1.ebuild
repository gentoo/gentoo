# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="Meta package for the KDE Applications collection"
KEYWORDS="~amd64 ~x86"
IUSE="accessibility pim sdk"

RDEPEND="
	$(add_kdeapps_dep kate)
	$(add_kdeapps_dep kdeadmin-meta)
	$(add_kdeapps_dep kdecore-meta)
	$(add_kdeapps_dep kdeedu-meta)
	$(add_kdeapps_dep kdegames-meta)
	$(add_kdeapps_dep kdegraphics-meta)
	$(add_kdeapps_dep kdemultimedia-meta)
	$(add_kdeapps_dep kdenetwork-meta)
	$(add_kdeapps_dep kdeutils-meta)
	accessibility? ( $(add_kdeapps_dep kdeaccessibility-meta) )
	pim? ( kde-apps/kdepim-meta:* )
	sdk? (
		$(add_kdeapps_dep kdesdk-meta)
		$(add_kdeapps_dep kdewebdev-meta)
	)
"
