# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Meta package to facilitate easy use of x11-themes/mate-themes"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| (
		(
			=x11-libs/gtk+-3.16*:3
			=x11-themes/mate-themes-1.10*:0/3.16
		)
		(
			=x11-libs/gtk+-3.18*:3
			=x11-themes/mate-themes-1.10*:0/3.18
		)
		=x11-themes/mate-themes-1.10*:0
	)"
