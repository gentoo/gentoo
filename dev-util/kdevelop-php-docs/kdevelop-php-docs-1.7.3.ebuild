# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdevelop"
WEBKIT_REQUIRED="always"
inherit kde4-base

DESCRIPTION="PHP documentation plugin for KDevelop 4"
LICENSE="GPL-2 LGPL-2"
IUSE="debug"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	!=dev-util/kdevelop-plugins-1.0.0
"
