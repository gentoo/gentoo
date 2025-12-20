# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Provides an uniform interface to access several encryption algorithms"
HOMEPAGE="https://mcrypt.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/mcrypt/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~s390 ~sparc x86 ~x64-macos"

DOCS=(
	AUTHORS NEWS README THANKS TODO ChangeLog
	doc/README.config doc/README.key doc/README.xtea
	doc/example.c
)

PATCHES=(
	"${FILESDIR}/${P}-rotate-mask.patch"
	"${FILESDIR}/${P}-autoconf-2.70.patch" #775113
	# http://sourceforge.net/tracker/index.php?func=detail&aid=1872801&group_id=87941&atid=584895
	"${FILESDIR}/${P}-uninitialized.patch"
	"${FILESDIR}/${P}-prototypes.patch"
	"${FILESDIR}/${P}-c99.patch"
	"${FILESDIR}/${P}-c99-2.patch"
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	mv libltdl/configure.in libltdl/configure.ac || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac libltdl/configure.ac || die

	eautoreconf # update stale autotools
}

src_configure() {
	# LTO type mismatch (bug #924867)
	append-flags -fno-strict-aliasing
	filter-lto

	default
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
