# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/efivar/efivar-0.15.ebuild,v 1.6 2015/06/25 14:04:18 floppym Exp $

EAPI=5

inherit multilib toolchain-funcs

DESCRIPTION="Tools and library to manipulate EFI variables"
HOMEPAGE="https://github.com/rhinstaller/efivar"
SRC_URI="https://github.com/rhinstaller/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 x86"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}"

src_configure() {
	tc-export CC
	export libdir="/usr/$(get_libdir)"
}
