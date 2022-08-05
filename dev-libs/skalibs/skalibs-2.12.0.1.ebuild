# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="General-purpose libraries from skarnet.org"
HOMEPAGE="https://www.skarnet.org/software/skalibs/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="doc ipv6"

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
		--datadir=/etc
		--dynlibdir=/usr/$(get_libdir)
		--libdir=/usr/$(get_libdir)/${PN}
		--sysdepdir=/usr/$(get_libdir)/${PN}
		--enable-clock
		--enable-shared
		$(use_enable ipv6)
	)

	econf "${myconf[@]}"
}
