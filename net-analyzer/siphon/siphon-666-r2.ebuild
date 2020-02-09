# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_P=${PN}-v.${PV}

DESCRIPTION="A portable passive network mapping suite"
HOMEPAGE="http://siphon.datanerds.net/"
SRC_URI="http://siphon.datanerds.net/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-log.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	insinto /etc
	doins osprints.conf
	dodoc README
}
