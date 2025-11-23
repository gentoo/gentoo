# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A tool for differing and merging directories"
HOMEPAGE="https://www.samba.org/ftp/paulus/"
SRC_URI="https://www.samba.org/ftp/paulus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86"

DEPEND="
	dev-lang/tk:=
	dev-lang/tcl:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-include.patch"
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-vcs.patch"
	"${FILESDIR}/${P}-tcl8.6.patch"
	"${FILESDIR}/${P}-funky-chars.patch"
)

src_configure() {
	tc-export CC
	append-cppflags -I"${ESYSROOT}"/usr/include/tcl
}

src_install() {
	dobin ${PN}
	dolib.so libfilecmp.so.0.0
	dosym libfilecmp.so.0.0 /usr/$(get_libdir)/libfilecmp.so.0
	dosym libfilecmp.so.0.0 /usr/$(get_libdir)/libfilecmp.so
	einstalldocs
}
