# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Utilities for PowerTab Guitar files (.ptb)"
HOMEPAGE="https://www.samba.org/~jelmer/ptabtools/"
SRC_URI="https://www.samba.org/~jelmer/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="
	dev-libs/popt:=
	dev-libs/libxml2:=
	dev-libs/libxslt:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	emake DESTDIR="${D}" libdir="/usr/$(get_libdir)" install
	einstalldocs

	# QA Notice: Missing soname symlink(s):
	#     usr/lib64/libptb.so.0 -> libptb.so.0.5.0
	dosym libptb.so.0.5.0 /usr/$(get_libdir)/libptb.so.0

	# Don't want static archives
	find "${D}" -name '*.a' -delete || die
}
