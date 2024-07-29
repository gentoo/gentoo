# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="A complete Web development framework"
HOMEPAGE="http://libre.adacore.com/tools/aws/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	https://github.com/AdaCore/templates-parser/archive/refs/tags/v${PV}.tar.gz
	-> templates-parser-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+shared ssl wsdl"

RDEPEND="dev-ada/gnatcoll-core:=[${ADA_USEDEP},shared?,static-libs]
	dev-ada/libgpr:=[${ADA_USEDEP},shared?,static-libs]
	dev-ada/xmlada:=[${ADA_USEDEP},shared?,static-libs]
	wsdl? (
		dev-ada/libadalang:=[${ADA_USEDEP},static-libs]
		dev-ada/langkit:=[${ADA_USEDEP},static-libs]
		dev-ada/gnatcoll-bindings:=[${ADA_USEDEP},gmp,iconv,static-libs]
		dev-libs/gmp
	)
	ssl? ( dev-libs/openssl )
	!dev-ada/templates-parser"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/${PN}-2020-gentoo.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	rmdir templates_parser || die
	mv ../templates-parser-${PV} templates_parser || die
}

src_configure() {
	emake -j1 setup prefix=/usr ZLIB=true XMLADA=true \
		GPRBUILD="/usr/bin/gprbuild -v" \
		ENABLE_SHARED=$(usex shared true false) \
		SOCKET=$(usex ssl openssl std) \
		LAL=$(usex wsdl true false) \
		PROCESSORS=$(makeopts_jobs) \
		SERVER_HTTP2=true \
		CLIENT_HTTP2=true
}

src_compile() {
	emake GPRBUILD="/usr/bin/gprbuild -v"
}

src_install() {
	emake -j1 install \
		DESTDIR="${D}" \
		PROCESSORS=$(makeopts_jobs) ENABLE_SHARED=true \
		GPRINSTALL="/usr/bin/gprinstall -v"
	einstalldocs
}
