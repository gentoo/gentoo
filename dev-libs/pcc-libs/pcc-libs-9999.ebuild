# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils versionator

DESCRIPTION="pcc compiler support libs"
HOMEPAGE="http://pcc.ludd.ltu.se"

if [[ ${PV} = 9999 ]]; then
	inherit cvs
	ECVS_SERVER="pcc.ludd.ltu.se:/cvsroot"
	ECVS_MODULE="${PN}"
	S="${WORKDIR}/${PN}"
	KEYWORDS=""
else
	SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="BSD"
SLOT="0"

IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	# not parallel-safe yet
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install
}
