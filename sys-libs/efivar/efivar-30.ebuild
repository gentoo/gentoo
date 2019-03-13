# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tools and library to manipulate EFI variables"
HOMEPAGE="https://github.com/rhinstaller/efivar"
SRC_URI="https://github.com/rhinstaller/efivar/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="amd64 ~arm ~arm64 ia64 x86"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.18
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i -e s/-Werror// gcc.specs || die
}

src_configure() {
	tc-export CC

	# https://github.com/rhinstaller/efivar/issues/64
	append-cflags -flto

	tc-ld-disable-gold
	export libdir="/usr/$(get_libdir)"
	unset LIBS # Bug 562004
}

src_compile() {
	# Avoid building static binary/libs
	opts=(
		BINTARGETS=efivar
		STATICLIBTARGETS=
	)
	emake "${opts[@]}"
}

src_install() {
	emake "${opts[@]}" DESTDIR="${D}" install
}
