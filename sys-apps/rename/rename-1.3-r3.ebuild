# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Easily rename files"
HOMEPAGE="http://rename.sourceforge.net/"
SRC_URI="http://${PN}/sourceforge.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${P}-rename.patch
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gcc44.patch
)

DOCS=( README ChangeLog )

src_prepare() {
	sed -i \
		-e '/^CFLAGS/s:-O3:@CFLAGS@:' \
		-e '/strip /s:.*::' \
		Makefile.in || die

	default

	# Clang 16
	eautoreconf
}

src_configure() {
	tc-export CC

	default
}

src_install() {
	newbin "${PN}" "${PN}xm"
	newman "${PN}.1" "${PN}xm.1"
}

pkg_postinst() {
	ewarn "This has been renamed to '${PN}xm' to avoid"
	ewarn "a naming conflict with sys-apps/util-linux."
}
