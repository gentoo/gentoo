# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing

MY_P=${PN}-gpl-${PV}-src

DESCRIPTION="A complete Web development framework"
HOMEPAGE="http://libre.adacore.com/tools/aws/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed001
	-> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnat_2016 +gnat_2017"

RDEPEND="dev-ada/xmlada[gnat_2016=,gnat_2017=,static-libs]"
DEPEND="${RDEPEND}
	dev-ada/gnat_util[gnat_2016(-)?,gnat_2017(-)?,static-libs]
	dev-ada/asis[gnat_2016(-)?,gnat_2017(-)?]
	dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?]"
REQUIRED_USE="^^ ( gnat_2016 gnat_2017 )"

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-2016-gentoo.patch )

src_configure() {
	emake -j1 setup prefix=/usr \
		GPRBUILD="/usr/bin/gprbuild -v"
}

src_compile() {
	emake \
		PROCESSORS=$(makeopts_jobs) \
		DEBUG=true \
		GPRBUILD="/usr/bin/gprbuild -v"
}

src_install() {
	emake DESTDIR="${D}" DEBUG=true install
	einstalldocs
}
