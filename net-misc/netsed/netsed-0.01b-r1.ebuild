# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Small tool for altering forwarded network data in real time"
HOMEPAGE="http://freshmeat.net/projects/netsed"
SRC_URI="mirror://gentoo/${P}.tgz
	mirror://gentoo/${PN}_0.01c-2.diff.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

S=${WORKDIR}

PATCHES=(
	netsed_0.01c-2.diff
)

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin netsed
	doman debian/netsed.1
	dodoc README
}
