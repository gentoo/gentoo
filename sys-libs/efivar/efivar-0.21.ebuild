# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Tools and library to manipulate EFI variables"
HOMEPAGE="https://github.com/rhinstaller/efivar"
SRC_URI="https://github.com/rhinstaller/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 x86"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/0.21-initializer.patch"
}

src_configure() {
	tc-export CC
	export libdir="/usr/$(get_libdir)"
}
