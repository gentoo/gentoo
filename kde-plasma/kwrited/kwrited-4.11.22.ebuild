# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE Plasma daemon listening for wall and write messages"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	|| ( >=sys-libs/libutempter-1.1.5 >=sys-freebsd/freebsd-lib-9.0 )
"
RDEPEND="${DEPEND}"
