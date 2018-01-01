# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P=${PN^^}_${PV}

DESCRIPTION="Greedy and progressive approaches for segment-based multiple sequence alignment"
HOMEPAGE="http://dialign-tx.gobics.de/"
SRC_URI="http://dialign-tx.gobics.de/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${MY_P}
PATCHES=(
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-implicits.patch
	"${FILESDIR}"/${P}-modernize.patch
	"${FILESDIR}"/${P}-gnu89-inline.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake -C source clean
	emake -C source
}

src_install() {
	dobin source/dialign-tx
	insinto /usr/$(get_libdir)/${PN}/conf
	doins -r conf/.
}

pkg_postinst() {
	einfo "The configuration directory is"
	einfo "${EROOT%/}/usr/$(get_libdir)/${PN}/conf"
	einfo "You will need to pass this to ${PN} on every run."
}
