# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing

MYP=${P}-20190429-18B77-src

DESCRIPTION="Ada unit testing framework"
HOMEPAGE="http://libre.adacore.com/tools/aunit/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf859431e87aa2cdf16b18
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 gnat_2018 +gnat_2019"

RDEPEND="gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )
	gnat_2018? ( dev-lang/gnat-gpl:7.3.1 )
	gnat_2019? ( dev-lang/gnat-gpl:8.3.1 )"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]"

REQUIRED_USE="^^ ( gnat_2016 gnat_2017 gnat_2018 gnat_2019 )"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2016-gentoo.patch )

src_compile() {
	emake GPRBUILD="gprbuild -j$(makeopts_jobs) -v"
}

src_install() {
	emake INSTALL="${D}"usr install
	einstalldocs
	mv "${D}"usr/share/doc/${PN}/* "${D}"usr/share/doc/${PF}/ || die
	rmdir "${D}"usr/share/doc/${PN} || die
	mv "${D}"usr/share/examples/${PN} "${D}"usr/share/doc/${PF}/examples || die
	rmdir "${D}"usr/share/examples || die
	rm -r "${D}"/usr/share/gpr/manifests || die
}

src_test() {
	emake PROJECT_PATH_ARG="ADA_PROJECT_PATH=$(pwd)/lib/gnat" -C test
}
