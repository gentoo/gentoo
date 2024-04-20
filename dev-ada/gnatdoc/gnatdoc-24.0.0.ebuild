# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="GNAT Documentation Generation Tool"
HOMEPAGE="https://github.com/AdaCore/gnatdoc"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="${ADA_DEPS}
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},gmp,iconv,shared,static-libs,static-pic]
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared,static-libs,static-pic]
	dev-ada/gpr[${ADA_USEDEP},shared,static-libs]
	dev-ada/gpr-unit-provider[${ADA_USEDEP},shared,static-libs]
	dev-ada/langkit[${ADA_USEDEP},shared,static-libs,static-pic]
	dev-ada/libadalang[${ADA_USEDEP},static-libs,static-pic]
	dev-ada/libgpr[${ADA_USEDEP},shared,static-libs,static-pic]
	dev-ada/markdown[${ADA_USEDEP}]
	>=dev-ada/VSS-24.0.0[${ADA_USEDEP},static-libs]
	dev-ada/xmlada[${ADA_USEDEP},shared,static-libs,static-pic]"
DEPEND="${RDEPEND}"

REQUIRED_USE="${ADA_REQUIRED_USE}"

src_compile() {
	gprbuild -v -j$(makeopts_jobs) -p -P gnat/libgnatdoc.gpr \
		-XLIBRARY_TYPE=relocatable || die
	gprbuild -v -j$(makeopts_jobs) -p -P gnat/gnatdoc.gpr \
		-XLIBRARY_TYPE=static || die
}

src_install() {
	gprinstall -v -p -P gnat/libgnatdoc.gpr \
		-XLIBRARY_TYPE=relocatable --prefix="${D}"/usr || die
	gprinstall -v -p -P gnat/gnatdoc.gpr \
		-XLIBRARY_TYPE=relocatable --prefix="${D}"/usr || die
}
