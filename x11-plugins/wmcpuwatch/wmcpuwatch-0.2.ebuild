# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="dockapp showing the load of every logical CPU on the system"
HOMEPAGE="https://bitbucket.org/StarFire/wmcpuwatch"
SRC_URI="https://bitbucket.org/StarFire/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/libdockapp-0.7:="
DEPEND="${RDEPEND}"
