# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="CVS frontend by KDE"
HOMEPAGE="https://www.kde.org/applications/development/cervisia"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

RDEPEND="
	dev-vcs/cvs
"
