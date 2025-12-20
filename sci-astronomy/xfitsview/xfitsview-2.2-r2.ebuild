# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=XFITSview
MY_P=${MY_PN}${PV}

DESCRIPTION="Viewer for astronomical images in FITS format"
HOMEPAGE="http://www.nrao.edu/software/fitsview/"
SRC_URI="ftp://ftp.cv.nrao.edu/fits/os-support/unix/xfitsview/${PN}${PV}.tgz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=x11-libs/motif-2.3:0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-build_system.patch )

src_prepare() {
	default
	find -name '*old.c' -delete || die
}

src_configure() {
	tc-export AR
	default
}

src_install() {
	dobin XFITSview
	dodoc README changes notes.text
}
