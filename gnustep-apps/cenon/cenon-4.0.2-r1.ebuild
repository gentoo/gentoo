# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit gnustep-2

S=${WORKDIR}/${PN/c/C}

DESCRIPTION="Cenon is a vector graphics tool for GNUstep, OpenStep and MacOSX"
HOMEPAGE="http://www.cenon.info/"
SRC_URI="http://www.cenon.zone/download/source/${P/c/C}.tar.bz2"
KEYWORDS="amd64 ~x86"
SLOT="0"
LICENSE="Cenon"
IUSE=""

DEPEND=""
RDEPEND=">=gnustep-libs/cenonlibrary-4.0.0"

src_prepare() {
	# Do not install files already provided by cenonlibrary
	epatch "${FILESDIR}"/${P}-install.patch

	epatch "${FILESDIR}"/${P}-check-return-value.patch
	epatch "${FILESDIR}"/${P}-gnustep-gui-0.24-support.patch
}
