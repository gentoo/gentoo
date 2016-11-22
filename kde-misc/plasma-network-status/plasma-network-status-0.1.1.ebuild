# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE applet to monitor the network interface status"
HOMEPAGE="https://sourceforge.net/projects/pa-net-stat/"
SRC_URI="mirror://sourceforge/pa-net-stat/${P}-Source.tar.bz2"

SLOT="4"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"

S="${WORKDIR}/${P}-Source"
