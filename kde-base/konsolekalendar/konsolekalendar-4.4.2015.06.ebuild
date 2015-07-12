# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konsolekalendar/konsolekalendar-4.4.2015.06.ebuild,v 1.1 2015/07/12 22:08:54 dilfridge Exp $

EAPI=5

KMNAME="kdepim"
KMMODULE="console/${PN}"
KDE_HANDBOOK=optional
inherit kde4-meta

DESCRIPTION="A command line interface to KDE calendars (noakonadi branch)"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs '' 4.6)
"
RDEPEND="${DEPEND}"
