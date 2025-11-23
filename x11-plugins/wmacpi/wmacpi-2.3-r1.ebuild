# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="DockApp ACPI status monitor for laptops"
HOMEPAGE="https://www.dockapps.net/wmacpi"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"
S="${WORKDIR}/dockapps"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 -ppc -sparc x86"

DEPEND="
	>=x11-libs/libdockapp-0.7:=
	x11-libs/libX11"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
	)

src_prepare() {
	default

	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i *.c || die
}

src_configure() {
	tc-export CC
}
