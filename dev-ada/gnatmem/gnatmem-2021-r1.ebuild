# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0..1} gcc_12_2_0 )
inherit ada multiprocessing autotools

MYP=${P}-${PV}0518-19F7B-src
ID=3ddb98c0c8854dc7631bebd673ac7bc53038d4b7
ADAMIRROR=https://community.download.adacore.com/v1

DESCRIPTION="Monitors dynamic allocation and deallocation activity in a program"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="${ADAMIRROR}/${ID}?filename=${MYP}.tar.gz -> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]
	sys-libs/binutils-libs:="

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

PATCHES=(
	"${FILESDIR}"/${PN}-2018-gentoo.patch
)

src_prepare() {
	default
	mv configure.in configure.ac
	eautoreconf
}

src_compile() {
	gprbuild -v -p -Pgnatmem.gpr -j$(makeopts_jobs) \
		-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} \
		-largs ${LDFLAGS} \
		|| die
}

src_install() {
	dobin obj/gnatmem
}
