# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Set of tiny portable unix utilities"
HOMEPAGE="https://www.skarnet.org/software/s6-portable-utils/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="static"

RDEPEND="!static? ( >=dev-libs/skalibs-2.11.2.0:= )"
DEPEND="${RDEPEND}
	static? ( >=dev-libs/skalibs-2.11.2.0[static-libs] )
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
		--with-lib=/usr/$(get_libdir)/skalibs
		--with-sysdeps=/usr/$(get_libdir)/skalibs
		$(use_enable static allstatic)
		$(use_enable static static-libc)
	)

	econf "${myconf[@]}"
}
