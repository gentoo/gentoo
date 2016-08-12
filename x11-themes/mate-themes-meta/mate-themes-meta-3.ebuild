# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == 9999 ]]; then
	MATE_THEMES_V=".9999"
else
	MATE_THEMES_V="*"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Meta package to facilitate easy use of x11-themes/mate-themes"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
IUSE="gtk2-only"

DEPEND=""
RDEPEND="|| (
		gtk2-only? (
			!!11-libs/gtk+:3
			x11-themes/mate-themes:0
		)
		(
			=x11-libs/gtk+-3.16*:3
			=x11-themes/mate-themes-3.16${MATE_THEMES_V}:0/3.16
		)
		(
			=x11-libs/gtk+-3.18*:3
			=x11-themes/mate-themes-3.18${MATE_THEMES_V}:0/3.18
		)
		(
			=x11-libs/gtk+-3.20*:3
			=x11-themes/mate-themes-3.20${MATE_THEMES_V}:0/3.20
		)
	)"
