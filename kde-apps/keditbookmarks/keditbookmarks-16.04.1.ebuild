# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kde-baseapps"
VIRTUALX_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="KDE's bookmarks editor"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkonq)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	lib/konq/
"
