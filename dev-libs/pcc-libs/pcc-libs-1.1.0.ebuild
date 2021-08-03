# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="pcc compiler support libs"
HOMEPAGE="http://pcc.ludd.ltu.se"
SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"
S="${WORKDIR}/${PN}-${PVR/*_pre/}/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	# not parallel-safe yet
	emake -j1
}
