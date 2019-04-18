# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

MY_P="${PN/-flim}-${PV}"
DESCRIPTION="aggregate is a tool for aggregating CIDR networks"
HOMEPAGE="http://horms.net/projects/aggregate/"
SRC_URI="http://horms.net/projects/aggregate/download/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND="dev-libs/vanessa-logger"
S=${WORKDIR}/${MY_P}

src_install() {
	newbin aggregate aggregate-flim
	newman aggregate.8 aggregate-flim.8
	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
