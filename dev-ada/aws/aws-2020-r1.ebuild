# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2019 gnat_202{0..1} )
inherit ada multiprocessing

MYP=${P}-${PV}0429-19A9F-src
ADAMIRROR=https://community.download.adacore.com/v1
ID=c1b0f6863d1a30acaee1df022a65ad11d5737a84

DESCRIPTION="A complete Web development framework"
HOMEPAGE="http://libre.adacore.com/tools/aws/"
SRC_URI="${ADAMIRROR}/${ID}?filename=${MYP}.tar.gz -> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-ada/xmlada[${ADA_USEDEP},shared,static-libs]"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
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
