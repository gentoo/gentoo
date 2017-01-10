# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs flag-o-matic

# Commit Date: Mon, 6 Apr 2015 22:42:56 +0200
COMMIT="fcd966966924e3d9af0954db56117e2f48767ea1"

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
	append-cflags "${includes} -fPIC"
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
