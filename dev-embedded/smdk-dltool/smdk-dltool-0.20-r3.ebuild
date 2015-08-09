# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs eutils

DESCRIPTION="Tool to communicate with Samsung SMDK boards"
HOMEPAGE="http://www.fluff.org/ben/smdk/tools/"
SRC_URI="http://www.fluff.org/ben/smdk/tools/downloads/smdk-tools-v${PV}.tar.gz"

# Email sent to author on 2012-01-18 querying about license
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"

S=${WORKDIR}/releases/smdk-tools-v${PV}/dltool

src_prepare() {
	epatch "${FILESDIR}"/${P}-add-S3C64xx-support.patch
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-libusb-1.0.patch
	tc-export CC PKG_CONFIG
}

src_install() {
	newbin dltool smdk-usbdl
	dodoc readme.txt
}
