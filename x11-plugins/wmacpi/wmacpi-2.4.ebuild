# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="DockApp ACPI status monitor for laptops"
HOMEPAGE="https://www.dockapps.net/wmacpi"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -ppc -sparc x86"

DEPEND=">=x11-libs/libdockapp-0.7:=
	x11-libs/libX11"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	)

src_compile() {
	emake CC="$(tc-getCC)"
}
