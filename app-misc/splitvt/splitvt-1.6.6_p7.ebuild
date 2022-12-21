# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN}-$(ver_cut 1-3)"
MY_DEB_P="${PN}_$(ver_cut 1-3)-$(ver_cut 5)"

DESCRIPTION="Splitting terminals into two shells"
HOMEPAGE="https://slouken.libsdl.org/projects/splitvt/"
SRC_URI="
	https://slouken.libsdl.org/projects/splitvt/${MY_P}.tar.gz
	mirror://debian/pool/main/s/splitvt/${MY_DEB_P}.diff.gz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-fix-build-for-clang16.patch.xz
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc sparc x86"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}"/${MY_DEB_P}.diff
	"${FILESDIR}"/1.6.6-ldflags.patch
	"${WORKDIR}"/${P}-fix-build-for-clang16.patch
)

DOCS=( ANNOUNCE BLURB CHANGES NOTES README TODO )

src_prepare() {
	default
	sed -i \
		-e "s|/usr/local/bin|${ED}/usr/bin|g" \
		-e "s|/usr/local/man/|${ED}/usr/share/man/|g" config.c || die
}

src_configure() {
	# upstream has their own homebrew configure script
	./configure || die "configure failed"
	sed -i \
		-e "s|-O2|${CFLAGS}|" \
		-e "s|^CC = gcc|CC = $(tc-getCC)|" Makefile || die
}

src_install() {
	dodir /usr/bin /usr/share/man/man1

	default

	fperms 755 /usr/bin/xsplitvt
	doman splitvt.1
}
