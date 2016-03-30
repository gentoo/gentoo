# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Framework based on Gettext for internationalizing user interface text"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtscript:5
	sys-devel/gettext
	virtual/libintl
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtconcurrent:5 )
"
