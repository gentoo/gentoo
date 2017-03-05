# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Frontend for Cachegrind by KDE"
HOMEPAGE="https://www.kde.org/applications/development/kcachegrind
https://kcachegrind.github.io/html/Home.html"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

RDEPEND="
	media-gfx/graphviz
"
