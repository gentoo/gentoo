# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdeaccessibility - merge this to pull in all kdeaccessiblity-derived packages"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_kdeapps_dep kmag)
	$(add_kdeapps_dep kmousetool)
	$(add_kdeapps_dep kmouth)
"
