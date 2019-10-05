# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_201{6,7,8,9} )
inherit ada multiprocessing

MY_P=${PN}-gpl-${PV}-src

DESCRIPTION="A complete Web development framework"
HOMEPAGE="http://libre.adacore.com/tools/aws/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819e0c7a447df26c27abd
	-> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-ada/xmlada[${ADA_USEDEP},shared,static-libs]"
DEPEND="${RDEPEND}
	dev-ada/asis[${ADA_USEDEP}]
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-2016-gentoo.patch
	"${FILESDIR}"/${PN}-2018-gentoo.patch
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
