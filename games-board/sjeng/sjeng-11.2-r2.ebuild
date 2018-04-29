# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Console based chess interface"
HOMEPAGE="http://sjeng.sourceforge.net/"
SRC_URI="mirror://sourceforge/sjeng/Sjeng-Free-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="sys-libs/gdbm:0="
DEPEND=${RDEPEND}

S="${WORKDIR}/Sjeng-Free-${PV}"
