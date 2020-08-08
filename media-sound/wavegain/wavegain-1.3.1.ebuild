# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ReplayGain for WAVE audio files"
HOMEPAGE="http://www.rarewares.org/files/others/"
SRC_URI="http://www.rarewares.org/files/others/${P}srcs.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${P/wavegain/WaveGain}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.1-makefile.patch
	"${FILESDIR}"/${PN}-1.3.1-fno-common.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
}
