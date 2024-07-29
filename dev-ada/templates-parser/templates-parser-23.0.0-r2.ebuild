# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="A template engine"
HOMEPAGE="https://github.com/AdaCore/templates-parser"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP},shared?,static-libs?]
	shared? ( dev-ada/xmlada[static-pic] )"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

IUSE="+shared static-libs"
REQUIRED_USE="|| ( shared static-libs )
	${ADA_REQUIRED_USE}"

src_configure() {
	emake PROCESSORS=$(makeopts_jobs) \
		DEFAULT_LIBRARY_TYPE=$(usex shared relocatable static) \
		ENABLE_STATIC=$(usex static-libs true false) \
		ENABLE_SHARED=$(usex shared true false) \
		prefix=/usr \
		setup
}

src_compile() {
	emake GPROPTS=-v
}

src_install() {
	emake DESTDIR="${D}" -j1 install
	einstalldocs
}
