# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="FastCGI Developer's Kit"
HOMEPAGE="http://www.fastcgi.com/"
SRC_URI="http://www.fastcgi.com/dist/fcgi-$(ver_cut 1-3)-SNAP-$(ver_cut 5).tar.gz"

LICENSE="FastCGI"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="html"

S="${WORKDIR}/${PN}-2.4.1-SNAP-0910052249"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-Makefile.patch
	"${FILESDIR}"/${PN}-2.4.0-clientdata-pointer.patch
	"${FILESDIR}"/${PN}-2.4.0-html-updates.patch
	"${FILESDIR}"/${PN}-2.4.1_pre0311112127-gcc44.patch
	"${FILESDIR}"/${P}-link.patch
	"${FILESDIR}"/${P}-poll.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install LIBRARY_PATH="${ED}"/usr/$(get_libdir)
	einstalldocs

	# install the manpages into the right place
	doman doc/*.[13]

	# Only install the html documentation if USE=html
	if use html; then
		docinto html
		dodoc -r doc/*/* images
	fi

	# install examples in the right place
	docinto examples
	dodoc examples/*.c

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
