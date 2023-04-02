# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Set of tiny portable unix utilities"
HOMEPAGE="https://www.skarnet.org/software/s6-portable-utils/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND=">=dev-libs/skalibs-2.13.0.0:="
DEPEND="${RDEPEND}"

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
		--dynlibdir="/$(get_libdir)"
		--libdir="/usr/$(get_libdir)/${PN}"
		--with-dynlib="/$(get_libdir)"
		--with-lib="/usr/$(get_libdir)/skalibs"
		--with-sysdeps="/usr/$(get_libdir)/skalibs"
		--disable-allstatic
		--disable-static
		--disable-static-libc
	)

	econf "${myconf[@]}"
}
