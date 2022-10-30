# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A Library to Access SMI MIB Information"
HOMEPAGE="https://www.ibr.cs.tu-bs.de/projects/libsmi/ https://gitlab.ibr.cs.tu-bs.de/nm/libsmi"
SRC_URI="https://www.ibr.cs.tu-bs.de/projects/libsmi/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
RESTRICT="test"

# libsmi-0.5.0-implicit-function-declarations.patch touches parser
BDEPEND="
	sys-devel/flex
	virtual/yacc
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0-implicit-function-declarations.patch
	"${FILESDIR}"/${PN}-0.5.0-clang-15-configure.patch
	"${FILESDIR}"/${PN}-0.5.0-fix-macro-clang16.patch
)

src_prepare() {
	default
	eautoreconf
}

src_test() {
	# sming test is known to fail and some other fail if LC_ALL!=C:
	# https://mail.ibr.cs.tu-bs.de/pipermail/libsmi/2008-March/001014.html
	sed -i '/^[[:space:]]*smidump-sming.test \\$/d' test/Makefile
	LC_ALL=C emake -j1 check
}

src_install() {
	default

	dodoc ANNOUNCE ChangeLog README THANKS TODO \
		doc/{*.txt,smi.dia,smi.dtd,smi.xsd} smi.conf-example

	find "${ED}" -name '*.la' -delete || die
}
