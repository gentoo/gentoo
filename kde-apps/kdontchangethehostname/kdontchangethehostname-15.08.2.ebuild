# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="Tool to inform KDE about a change in hostname"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	x11-apps/xauth
"
