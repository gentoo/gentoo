# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Tools and library to manipulate EFI variables"
HOMEPAGE="https://github.com/rhinstaller/efivar"
SRC_URI="https://github.com/rhinstaller/efivar/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ia64 ~x86"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.18"

src_prepare() {
	default
	sed -i -e s/-Werror// gcc.specs || die
}

src_configure() {
	tc-export CC
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
