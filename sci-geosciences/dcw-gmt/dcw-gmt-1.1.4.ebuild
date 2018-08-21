# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Digital Chart of the World for GMT 5 or later"
HOMEPAGE="https://www.soest.hawaii.edu/wessel/dcw/"
SRC_URI="https://www.soest.hawaii.edu/pwessel/dcw/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dodoc README.TXT ChangeLog
	insinto /usr/share/dcw-gmt
	doins *.nc dcw-{countries,states}.txt
}
