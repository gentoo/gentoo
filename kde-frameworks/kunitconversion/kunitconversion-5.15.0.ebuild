# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Framework for converting units"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep ki18n)
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}"
