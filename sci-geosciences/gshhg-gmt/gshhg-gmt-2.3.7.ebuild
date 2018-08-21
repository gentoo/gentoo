# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A Global Self-consistent, Hierarchical, High-resolution Geography Database"
HOMEPAGE="https://www.soest.hawaii.edu/pwessel/gshhg/"
SRC_URI="https://www.soest.hawaii.edu/pwessel/gshhg/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dodoc README.TXT
	insinto /usr/share/gshhg
	doins *.nc
}
