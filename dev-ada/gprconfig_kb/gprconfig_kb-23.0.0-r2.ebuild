# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12_2_0 gcc_12 )

inherit ada

DESCRIPTION="GPR configuration knowledge base"
HOMEPAGE="https://www.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!=dev-ada/gprbuild-2021*"

REQUIRED_USE="${ADA_REQUIRED_USE}"
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default

	sed -i \
		-e "s:@VER@:${GCC_PV}:g" \
		db/compilers.xml \
		db/gnat.xml \
		db/c.xml \
		db/linker.xml \
		|| die
}

src_install() {
	insinto /usr/share/gprconfig
	doins db/*.xml
	doins db/*.ent
	einstalldocs
}
