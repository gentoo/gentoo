# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

MY_P="${P/-/_}"
DEB_PL="7"

DESCRIPTION="Splitting terminals into two shells"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	https://slouken.libsdl.org/projects/splitvt/${P}.tar.gz
	mirror://debian/pool/main/s/splitvt/${MY_P}-${DEB_PL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc sparc x86"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}"/${MY_P}-${DEB_PL}.diff
	"${FILESDIR}"/${PV}-ldflags.patch
)

DOCS=( ANNOUNCE BLURB CHANGES NOTES README TODO )

src_prepare() {
	default
	sed -i \
		-e "s:/usr/local/bin:${D}/usr/bin:g" \
		-e "s:/usr/local/man/:${D}/usr/share/man/:g" config.c || die
}

src_configure() {
	# upstream has their own weirdo configure script...
	./configure || die "configure failed"
	sed -i \
		-e "s:-O2:${CFLAGS}:" \
		-e "s:^CC = gcc:CC = $(tc-getCC):" Makefile || die
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	default
	fperms 755 /usr/bin/xsplitvt
	doman splitvt.1
}
