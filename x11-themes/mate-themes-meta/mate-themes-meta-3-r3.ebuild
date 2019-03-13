# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package to facilitate easy use of x11-themes/mate-themes"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:MATE"
SRC_URI=""

KEYWORDS="amd64 ~arm ~arm64 x86"
LICENSE="metapackage"
SLOT="0"
IUSE="gtk2-only"

DEPEND=""
RDEPEND="|| (
		gtk2-only? (
			!!x11-libs/gtk+:3
			x11-themes/mate-themes:0
		)
		(
			>=x11-libs/gtk+-3.22:3
			>=x11-themes/mate-themes-3.22.18
		)
	)"
