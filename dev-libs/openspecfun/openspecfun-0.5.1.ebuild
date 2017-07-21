# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fortran-2 multilib

DESCRIPTION="A collection of special mathematical functions"
HOMEPAGE="http://julialang.org/"
SRC_URI="https://github.com/JuliaLang/openspecfun/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="sci-libs/openlibm"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s:/lib:/$(get_libdir):" Make.inc || die
	default
}

src_compile() {
	emake prefix="${EPREFIX}/usr" USE_OPENLIBM=1
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" install
	use static-libs || rm "${D}/${EPREFIX}/usr/$(get_libdir)/libopenspecfun.a" || die "rm failed"
	dodoc README.md
}
