# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Local simulator for testing Linux QoS disciplines"
HOMEPAGE="http://luxik.cdi.cz/~devik/qos/ethloop/"
SRC_URI="http://luxik.cdi.cz/~devik/qos/${PN}/${PN}${PV}.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="mirror bindist"

S=${WORKDIR}/${PN}
PATCHES=(
	"${FILESDIR}"/${P}-misc.patch
)

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin ethloop
}
