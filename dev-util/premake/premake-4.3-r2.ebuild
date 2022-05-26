# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A makefile generation tool"
HOMEPAGE="http://industriousone.com/premake"
SRC_URI="mirror://sourceforge/premake/${P}-src.zip"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ppc x86"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/archless.patch
)

src_compile() {
	emake -C build/gmake.unix/
}

src_install() {
	dobin bin/release/premake4
}
