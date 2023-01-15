# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2021 )
inherit ada multiprocessing

DESCRIPTION="A complete Web development framework"
HOMEPAGE="http://libre.adacore.com/tools/aws/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	https://github.com/AdaCore/templates-parser/archive/refs/tags/v${PV}.tar.gz
	-> templates-parser-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-ada/gnatcoll-core:=[${ADA_USEDEP},shared,static-libs]
	dev-libs/openssl"
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
	emake -j1 setup prefix=/usr ENABLE_SHARED=true \
		ZLIB=true SOCKET=openssl \
		GPRBUILD="/usr/bin/gprbuild -v"
}

src_compile() {
	emake \
		PROCESSORS=$(makeopts_jobs) ENABLE_SHARED=true \
		GPRBUILD="/usr/bin/gprbuild -v"
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PROCESSORS=$(makeopts_jobs) ENABLE_SHARED=true \
		GPRINSTALL="/usr/bin/gprinstall -v"
	einstalldocs
}
