# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool to communicate with Samsung SMDK boards"
HOMEPAGE="http://www.fluff.org/ben/smdk/tools/"
SRC_URI="http://www.fluff.org/ben/smdk/tools/downloads/smdk-tools-v${PV}.tar.gz"

# Email sent to author on 2012-01-18 querying about license
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/releases/smdk-tools-v${PV}/dltool"

PATCHES=(
	"${FILESDIR}"/${P}-add-S3C64xx-support.patch
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-libusb-1.0-r1.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	newbin dltool smdk-usbdl
	dodoc readme.txt
}
