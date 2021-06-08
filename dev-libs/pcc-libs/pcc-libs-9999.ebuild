# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="pcc compiler support libs"
HOMEPAGE="http://pcc.ludd.ltu.se"

if [[ ${PV} == 9999 ]]; then
	ECVS_SERVER="pcc.ludd.ltu.se:/cvsroot"
	ECVS_MODULE="${PN}"
	inherit cvs
	S="${WORKDIR}/${PN}"
else
	SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="BSD"
SLOT="0"

src_compile() {
	# not parallel-safe yet
	emake -j1
}
