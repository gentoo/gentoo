# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils versionator

DESCRIPTION="pcc compiler support libs"
HOMEPAGE="http://pcc.ludd.ltu.se"

SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}-${PVR/*_pre/}/

src_compile() {
	# not parallel-safe yet
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install
}
