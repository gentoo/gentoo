# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing

MY_P=${PN}-gpl-${PV}-src

DESCRIPTION="A complete Web development framework"
HOMEPAGE="http://libre.adacore.com/tools/aws/"
SRC_URI="http://mirrors.cdn.adacore.com/art/57399112c7a447658d00e1cd -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-ada/xmlada[static]"
DEPEND="${RDEPEND}
	dev-ada/gnat_util[static]
	dev-ada/asis
	dev-ada/gprbuild"

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	emake -j1 setup prefix=/usr
}

src_compile() {
	emake PROCESSORS=$(makeopts_jobs)
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
