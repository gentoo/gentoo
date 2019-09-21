# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

DESCRIPTION="Library for easy processing of keyboard entry from terminal-based programs"
HOMEPAGE="http://www.leonerd.org.uk/code/libtermkey/"
SRC_URI="http://www.leonerd.org.uk/code/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="demos static-libs"

RDEPEND="dev-libs/unibilium:="
DEPEND="${RDEPEND}
	sys-devel/libtool
	virtual/pkgconfig
	demos? ( dev-libs/glib:2 )"

src_prepare() {
	default

	if ! use demos; then
		sed -e '/^all:/s:$(DEMOS)::' -i Makefile || die
	fi
}

src_compile() {
	append-flags -fPIC
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" all
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" DESTDIR="${D}" install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/${PN}.a || die
	rm "${ED}"/usr/$(get_libdir)/${PN}.la || die
}
