# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2019 )
inherit ada multiprocessing

MY_P=${P}-20190512-18AB9-src

DESCRIPTION="A complete Web development framework"
HOMEPAGE="http://libre.adacore.com/tools/aws/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf85a031e87aa2cdf16b19
	-> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-ada/xmlada[${ADA_USEDEP},shared,static-libs]"
DEPEND="${RDEPEND}
	dev-ada/asis[${ADA_USEDEP}]
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-2016-gentoo.patch
)

src_configure() {
	emake -j1 setup prefix=/usr ENABLE_SHARED=true \
		GPRBUILD="/usr/bin/gprbuild -v"
}

src_compile() {
	emake \
		PROCESSORS=$(makeopts_jobs) \
		GPRBUILD="/usr/bin/gprbuild -v"
}
