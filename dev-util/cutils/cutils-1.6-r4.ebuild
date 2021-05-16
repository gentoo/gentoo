# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C language utilities"
HOMEPAGE="http://www.sigala.it/sandro/software.php#cutils"
SRC_URI="http://www.sigala.it/sandro/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/${PN}-infopage.patch
	"${FILESDIR}"/${P}-case-insensitive.patch
)

src_prepare() {
	default

	mv src/cdecl/{,cutils-}cdecl.1 || die

	# delete pointless README
	rm README.compile || die

	# Force rebuild of cutils.info
	rm doc/cutils.info || die

	sed -e "s/cdecl/cutils-cdecl/g"	\
		-i doc/cutils.texi || die
	sed -e "/PROG/s/cdecl/cutils-cdecl/" \
		-i src/cdecl/Makefile.in || die
	sed -e "/Xr/s/cdecl/cutils-cdecl/" \
		-i src/cundecl/cundecl.1 || die
	sed -e "/Nm/s/cdecl/cutils-cdecl/" \
		-i src/cdecl/cutils-cdecl.1 || die
}

src_compile() {
	emake CC="$(tc-getCC)" -j1
}

src_install() {
	default
	dodoc HISTORY
}

pkg_postinst() {
	elog "cdecl was installed as cutils-cdecl because of a naming conflict"
	elog "with dev-util/cdecl."
}
