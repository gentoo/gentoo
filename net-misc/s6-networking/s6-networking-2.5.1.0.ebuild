# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Suite of small networking utilities for Unix systems"
HOMEPAGE="https://www.skarnet.org/software/s6-networking/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="ssl static static-libs"

REQUIRED_USE="static? ( static-libs )
	ssl? ( !static !static-libs )"

RDEPEND=">=dev-lang/execline-2.8.1.0:=[static-libs?]
	>=dev-libs/skalibs-2.11.0.0:=[static-libs?]
	>=sys-apps/s6-2.11.0.0:=[execline,static-libs?]
	ssl? ( dev-libs/libretls )
	!static? (
		>=net-dns/s6-dns-2.3.5.2:=
	)
"
DEPEND="${RDEPEND}
	>=net-dns/s6-dns-2.3.5.2[static-libs?]
"

HTML_DOCS=( doc/. )

src_prepare() {
	default

	# Avoid QA warning for LDFLAGS addition
	sed -i -e 's/.*-Wl,--hash-style=both$/:/' configure || die

	sed -i -e '/AR := /d' -e '/RANLIB := /d' Makefile || die
}

src_configure() {
	tc-export AR CC RANLIB

	local myconf=(
		--bindir=/bin
		--dynlibdir=/usr/$(get_libdir)
		--libdir=/usr/$(get_libdir)/${PN}
		--with-dynlib=/usr/$(get_libdir)
		--with-lib=/usr/$(get_libdir)/s6
		--with-lib=/usr/$(get_libdir)/s6-dns
		--with-lib=/usr/$(get_libdir)/skalibs
		--with-sysdeps=/usr/$(get_libdir)/skalibs
		--enable-shared
		$(use_enable ssl ssl libtls)
		$(use_enable static allstatic)
		$(use_enable static static-libc)
		$(use_enable static-libs static)
	)

	econf "${myconf[@]}"
}
