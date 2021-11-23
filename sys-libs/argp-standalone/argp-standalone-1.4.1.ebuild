# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Standalone argp library for use with musl"
HOMEPAGE="https://github.com/ericonr/argp-standalone"
SRC_URI="https://github.com/ericonr/argp-standalone/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain GPL-2 GPL-3 XC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~x86"
IUSE="static-libs"

DEPEND="!sys-libs/glibc"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cflags "-fgnu89-inline"

	econf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	insinto /usr/include
	doins argp.h
}
