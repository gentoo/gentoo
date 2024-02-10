# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="ReplayGain for WAVE audio files"
HOMEPAGE="https://www.rarewares.org/files/others/"
SRC_URI="https://www.rarewares.org/files/others/${P}srcs.zip"
S="${WORKDIR}/WaveGain-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.1-makefile.patch
	"${FILESDIR}"/${PN}-1.3.1-fno-common.patch
	"${FILESDIR}"/${PN}-1.3.1-clang16.patch
)

src_configure() {
	tc-export CC
	append-cflags -fno-strict-aliasing #860981
}

src_install() {
	dobin ${PN}
}
