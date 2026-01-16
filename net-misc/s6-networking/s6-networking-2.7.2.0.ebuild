# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs

DESCRIPTION="Suite of small networking utilities for Unix systems"
HOMEPAGE="https://www.skarnet.org/software/s6-networking/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="ssl"

RDEPEND="
	dev-lang/execline:=
	>=dev-libs/skalibs-2.14.5.0:=
	>=net-dns/s6-dns-2.3.7.0:=
	sys-apps/s6:=[execline]
	ssl? ( dev-libs/libretls:= )
"
DEPEND="${RDEPEND}"

HTML_DOCS=( doc/. )

src_prepare() {
	default

	# Remove files that were accidentaly included to the release tar ball
	rm -f libstls.{pc,{a,so}.xyzzy} || die

	# Avoid QA warning for LDFLAGS addition
	sed -i -e 's/.*-Wl,--hash-style=both$/:/' configure || die

	sed -i -e '/AR := /d' -e '/RANLIB := /d' Makefile || die
}

src_configure() {
	tc-export AR CC RANLIB

	local myconf=(
		--bindir=/bin
		--dynlibdir="/$(get_libdir)"
		--libdir="/usr/$(get_libdir)/${PN}"
		--with-dynlib="/$(get_libdir)"
		--with-lib="/usr/$(get_libdir)/s6"
		--with-lib="/usr/$(get_libdir)/s6-dns"
		--with-lib="/usr/$(get_libdir)/skalibs"
		--with-sysdeps="/usr/$(get_libdir)/skalibs"

		--enable-pkgconfig
		--pkgconfdir="/usr/$(get_libdir)/pkgconfig"

		--enable-shared
		--disable-allstatic
		--disable-static
		--disable-static-libc
		$(use_enable ssl ssl libtls)
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	optfeature "man pages" app-doc/s6-networking-man-pages
}
