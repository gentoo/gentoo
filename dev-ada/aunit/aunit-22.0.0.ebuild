# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0..1} gcc_12_2_0 )
inherit ada multiprocessing

DESCRIPTION="Ada unit testing framework"
HOMEPAGE="http://libre.adacore.com/tools/aunit/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/${PN}-2016-gentoo.patch
	"${FILESDIR}"/${P}-redundant.patch
)

src_compile() {
	emake GPRBUILD="gprbuild -j$(makeopts_jobs) -v"
}

src_install() {
	emake INSTALL="${D}"/usr install
	einstalldocs
	mv "${D}"/usr/share/examples/${PN} "${D}"/usr/share/doc/${PF}/examples || die
	rmdir "${D}"/usr/share/examples || die
	rm -r "${D}"/usr/share/gpr/manifests || die
}

src_test() {
	emake PROJECT_PATH_ARG="ADA_PROJECT_PATH=$(pwd)/lib/gnat" -C test
}
