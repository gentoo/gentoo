# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=${PN/elf/ELF}-${PV}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="collection of programs to manipulate ELF files: sstrip, rebind, elfls, elftoc"
HOMEPAGE="http://www.muppetlabs.com/~breadbox/software/elfkickers.html"
SRC_URI="http://www.muppetlabs.com/~breadbox/pub/software/${MY_PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips sparc x86"
IUSE="doc"

DEPEND="app-misc/pax-utils"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-3.1-respect-CFLAGS-LDFLAGS.patch
	"${FILESDIR}"/${PN}-3.1-create-destdir-path.patch
	"${FILESDIR}"/add-freebsd-elf-defs.patch
)

src_prepare() {
	default
	sed -i -e "s:^prefix = /usr/local:prefix = ${D}:" Makefile \
		|| die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC) all
}
