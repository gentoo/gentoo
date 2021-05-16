# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="All the official E16 themes"
HOMEPAGE="https://www.enlightenment.org https://sourceforge.net/projects/enlightenment/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	!x11-themes/etheme-BlueSteel
	!x11-themes/etheme-BrushedMetal-Tigert
	!x11-themes/etheme-Ganymede
	!x11-themes/etheme-ShinyMetal
	!x11-themes/ethemes
"
