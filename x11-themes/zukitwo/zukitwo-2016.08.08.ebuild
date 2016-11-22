# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Transition package to zuki-themes"
HOMEPAGE="http://gnome-look.org/content/show.php/Zukitwo?content=140562"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-shell"

RDEPEND="x11-themes/zuki-themes[gnome-shell?]"
DEPEND=""
