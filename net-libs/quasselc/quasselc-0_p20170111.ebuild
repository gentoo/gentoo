# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

# Commit Date: Wed Jan 11 18:27:31 2017 +0100
COMMIT="a0a1e6bd87d3eac68b5369972d1c2035cfe47e94"

DESCRIPTION="API for accessing Quassel using C"
HOMEPAGE="https://github.com/phhusson/QuasselC"
SRC_URI="https://github.com/phhusson/QuasselC/archive/${COMMIT}.zip -> ${PF}.zip"

LICENSE="GPL-3 LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/pkgconfig"

S="${WORKDIR}/QuasselC-${COMMIT}"

src_prepare() {
	default

	# Makefile hardcodes much
	sed -e '/^CFLAGS/d' -i Makefile || die
	local includes=$($(tc-getPKG_CONFIG) glib-2.0 --cflags)
	append-cflags "${includes} -fPIC -std=gnu11"
}

src_compile() {
	tc-export CC
	export prefix="${ROOT}usr" libdir="${ROOT}usr/$(get_libdir)"
	default
}

src_install() {
	default
	dosym "libquasselc.so.0" "/usr/$(get_libdir)/libquasselc.so"
}
