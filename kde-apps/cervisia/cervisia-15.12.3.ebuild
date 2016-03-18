# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="A KDE CVS frontend"
HOMEPAGE="https://www.kde.org/applications/development/cervisia"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-vcs/cvs
"
