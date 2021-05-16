# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Run real-mode video BIOS code to alter hw state (i.e. reinitialize video card)"
HOMEPAGE="http://www.codon.org.uk/~mjg59/vbetool/"
SRC_URI="http://www.codon.org.uk/~mjg59/vbetool/download/vbetool-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	sys-libs/zlib
	sys-apps/pciutils
	>=dev-libs/libx86-1.1-r1"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.0-build.patch )

src_prepare() {
	default

	eaclocal # temp fix for #439614
	eautoreconf
}

src_configure() {
	econf --with-x86emu
}
