# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwrited/kwrited-4.11.21.ebuild,v 1.1 2015/07/02 13:23:00 mrueg Exp $

EAPI=5
KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE daemon listening for wall and write messages"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	|| ( >=sys-libs/libutempter-1.1.5 >=sys-freebsd/freebsd-lib-9.0 )
"
RDEPEND="${DEPEND}"
