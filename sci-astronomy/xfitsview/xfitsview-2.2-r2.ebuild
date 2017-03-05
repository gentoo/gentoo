# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=XFITSview
MY_P=${MY_PN}${PV}

DESCRIPTION="Viewer for astronomical images in FITS format"
HOMEPAGE="http://www.nrao.edu/software/fitsview/"
SRC_URI="ftp://ftp.cv.nrao.edu/fits/os-support/unix/xfitsview/${PN}${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=x11-libs/motif-2.3:0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

DOCS=( README changes notes.text )
PATCHES=( "${FILESDIR}"/${P}-build_system.patch )

src_prepare() {
	default
	find "${S}" -name '*old.c' -delete || die
}

src_install() {
	dobin XFITSview
	einstalldocs
}
