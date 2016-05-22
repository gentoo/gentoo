# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="Meta package for the KDE Applications collection"
KEYWORDS=" ~amd64 ~x86"
IUSE="accessibility minimal nls pim sdk"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

# KDE PIM 15.08.3 is not going to be in tree and
# will conflict with other packages from 15.08.3
# Raise kdeedu-meta dep whenever it hits portage
RDEPEND="
	$(add_kdeapps_dep kate)
	$(add_kdeapps_dep kdeadmin-meta)
	$(add_kdeapps_dep kdecore-meta)
	$(add_kdeapps_dep kdeedu-meta '' 4.14.3)
	$(add_kdeapps_dep kdegames-meta)
	$(add_kdeapps_dep kdegraphics-meta)
	$(add_kdeapps_dep kdemultimedia-meta)
	$(add_kdeapps_dep kdenetwork-meta)
	$(add_kdeapps_dep kdeutils-meta)
	accessibility? ( $(add_kdeapps_dep kdeaccessibility-meta) )
	nls? (
		$(add_kdeapps_dep kde-l10n '' ${L10N_MINIMAL})
		$(add_kdeapps_dep kde4-l10n 'minimal' ${L10N_MINIMAL})
	)
	pim? ( >=kde-apps/kdepim-meta-4.4.2015:4 )
	sdk? (
		$(add_kdeapps_dep kdesdk-meta)
		$(add_kdeapps_dep kdewebdev-meta)
	)
	!minimal? ( $(add_kdeapps_dep kdeartwork-meta) )
"
