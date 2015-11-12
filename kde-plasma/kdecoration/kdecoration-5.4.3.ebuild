# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_PUNT_BOGUS_DEPS="true"
inherit kde5

DESCRIPTION="Plugin based library to create window decorations"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:5"
RDEPEND="${DEPEND}"
