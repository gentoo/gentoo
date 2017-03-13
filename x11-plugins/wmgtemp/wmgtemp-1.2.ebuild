# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="CPU and SYS temperature dockapp"
HOMEPAGE="http://www.dockapps.net/wmgtemp"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/lm_sensors:=
	>=x11-libs/libdockapp-0.7:=
	x11-libs/libX11"
RDEPEND="${DEPEND}"
