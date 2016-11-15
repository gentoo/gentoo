# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library to determine holidays and other special events for a geographical region"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_qt_dep qtdeclarative)
"
RDEPEND="${DEPEND}"

# bug 579592
RESTRICT="test"
