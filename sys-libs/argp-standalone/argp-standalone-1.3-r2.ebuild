# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Standalone argp library for use with uclibc"
HOMEPAGE="http://www.lysator.liu.se/~nisse/misc/"
SRC_URI="http://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz"

LICENSE="public-domain GPL-2 GPL-3 XC"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~m68k ~mips ~ppc ~s390 ~sh x86"
IUSE="static-libs"

DEPEND="!sys-libs/glibc"

PATCHES=(
	"${FILESDIR}/${P}-throw-in-funcdef.patch"
	"${FILESDIR}/${P}-shared.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags "-fgnu89-inline"
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	insinto /usr/include
	doins argp.h
}
