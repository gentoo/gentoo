# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="returns the disc id for the cd in the cd-rom drive"
HOMEPAGE="https://github.com/taem/cd-discid"
SRC_URI="https://github.com/taem/${PN}/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-upstream-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~riscv x86"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr STRIP="${EPREFIX}"/bin/true install
	dodoc changelog README
}
