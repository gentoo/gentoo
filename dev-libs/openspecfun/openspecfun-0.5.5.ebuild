# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 toolchain-funcs

DESCRIPTION="A collection of special mathematical functions"
HOMEPAGE="https://julialang.org"
SRC_URI="https://github.com/JuliaLang/openspecfun/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux"

DEPEND="sci-libs/openlibm:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_configure() {
	tc-export CC
}

src_compile() {
	emake \
		prefix="${EPREFIX}"/usr \
		libdir="${EPREFIX}"/usr/$(get_libdir) \
		USE_OPENLIBM=1
}

src_install() {
	emake \
		prefix="${EPREFIX}"/usr \
		libdir="${EPREFIX}"/usr/$(get_libdir) \
		DESTDIR="${D}" \
		install
	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
