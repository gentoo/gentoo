# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Multiple precision interval arithmetic library based on MPFR"
HOMEPAGE="https://perso.ens-lyon.fr/nathalie.revol/software.html"
SRC_URI=" https://perso.ens-lyon.fr/nathalie.revol/softwares/${PN}-1.5.4.tar.xz -> ${P}.tar.xz"
S="${WORKDIR}/${PN}-1.5.4"
# COPYING is GPL-3, COPYING.LESSER is LGPL-3, source file headers
# are LGPL-2.1+
LICENSE="GPL-3 LGPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.5.4-fix-tests.patch" )

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
