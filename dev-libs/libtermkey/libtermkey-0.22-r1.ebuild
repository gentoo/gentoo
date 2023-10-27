# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Library for easy processing of keyboard entry from terminal-based programs"
HOMEPAGE="http://www.leonerd.org.uk/code/libtermkey/"
SRC_URI="http://www.leonerd.org.uk/code/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86 ~x64-macos"
IUSE="demos static-libs"

RDEPEND="dev-libs/unibilium:="
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig
	demos? ( dev-libs/glib:2 )
"

PATCHES=(
	"${FILESDIR}"/no-automagic-manpages-compress.patch
)

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
	doman "${S}"/man/*.3
	doman "${S}"/man/*.7
}
