# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A very basic terminfo library"
HOMEPAGE="https://github.com/mauke/unibilium/"
SRC_URI="https://github.com/mauke/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+ MIT"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

BDEPEND="
	dev-lang/perl
"
DEPEND="
sys-devel/libtool
"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0-no-compress-man.patch
)

src_compile() {
	append-flags -fPIC
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" all
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" DESTDIR="${D}" install

	find "${D}" -name '*.la' -delete || die
	if ! use static-libs; then
		find "${ED}" -name '*.a' ! -name '*.dll.a' -delete || die
	fi
}
