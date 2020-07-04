# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_201{6,7,8,9} )
inherit ada multiprocessing

MYP=${P}-20190429-18B77-src

DESCRIPTION="Ada unit testing framework"
HOMEPAGE="http://libre.adacore.com/tools/aunit/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf859431e87aa2cdf16b18
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2016-gentoo.patch )

src_compile() {
	emake GPRBUILD="gprbuild -j$(makeopts_jobs) -v"
}

src_install() {
	emake INSTALL="${D}"/usr install
	einstalldocs
	mv "${D}"/usr/share/doc/${PN}/* "${D}"/usr/share/doc/${PF}/ || die
	rmdir "${D}"/usr/share/doc/${PN} || die
	mv "${D}"/usr/share/examples/${PN} "${D}"/usr/share/doc/${PF}/examples || die
	rmdir "${D}"/usr/share/examples || die
	rm -r "${D}"/usr/share/gpr/manifests || die
}

src_test() {
	emake PROJECT_PATH_ARG="ADA_PROJECT_PATH=$(pwd)/lib/gnat" -C test
}
