# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="User-space application to modify the EFI boot manager"
HOMEPAGE="https://github.com/rhinstaller/efibootmgr"
SRC_URI="https://github.com/rhboot/efibootmgr/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ~riscv x86"

RDEPEND="
	dev-libs/popt
	sys-apps/pciutils
	>=sys-libs/efivar-37:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i 's/-Werror //' Make.defaults || die
}

src_configure() {
	tc-export CC
	export EFIDIR="Gentoo"
}

src_compile() {
	emake PKG_CONFIG="$(tc-getPKG_CONFIG)"
}
