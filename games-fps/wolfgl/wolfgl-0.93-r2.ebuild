# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
#ECVS_SERVER="wolfgl.cvs.sourceforge.net:/cvsroot/wolfgl"
#ECVS_MODULE="wolfgl"
#inherit cvs

inherit eutils

DESCRIPTION="Wolfenstein and Spear of Destiny port using OpenGL"
HOMEPAGE="http://wolfgl.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tbz2
	mirror://sourceforge/wolfgl/wolfdata.zip
	mirror://sourceforge/wolfgl/sdmdata.zip"
#	mirror://sourceforge/wolfgl/wolfglx-wl6-${PV}.zip
#	mirror://sourceforge/wolfgl/wolfglx-sod-${PV}.zip

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${PV}-gcc.patch
	"${FILESDIR}"/${PV}-sample-rate.patch
	"${FILESDIR}"/${PV}-sprite.patch
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${PV}-gcc4.patch
)

src_compile() {
	emake -j1 CFLAGS="${CFLAGS}" DATADIR="/usr/share/${PN}"
}

src_install() {
	newbin linux/SDM/wolfgl wolfgl-sdm
	newbin linux/SOD/wolfgl wolfgl-sod
	newbin linux/WL1/wolfgl wolfgl-wl1
	newbin linux/WL6/wolfgl wolfgl-wl6

	insinto /usr/share/${PN}
	doins "${WORKDIR}"/*.{sdm,wl1}
}

pkg_postinst() {
	elog "This installed the shareware data files for"
	elog "Wolfenstein 3D and Spear Of Destiny."
	elog "If you wish to play the full versions just"
	elog "copy the data files to /usr/share/${PN}/"
}
