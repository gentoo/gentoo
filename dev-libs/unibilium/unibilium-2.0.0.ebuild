# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

DESCRIPTION="A very basic terminfo library"
HOMEPAGE="https://github.com/mauke/unibilium/"
SRC_URI="https://github.com/mauke/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+ MIT"
SLOT="0/4"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	dev-lang/perl
	sys-devel/libtool"

RDEPEND=""

src_compile() {
	append-flags -fPIC
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" all
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" DESTDIR="${D}" install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/lib${PN}.a || die
	rm "${ED}"/usr/$(get_libdir)/lib${PN}.la || die
}
