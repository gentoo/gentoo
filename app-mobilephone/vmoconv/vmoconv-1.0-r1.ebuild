# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A tool that converts Siemens phones VMO and VMI audio files to gsm and wav"
HOMEPAGE="http://triq.net/obex/"
SRC_URI="http://triq.net/obexftp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="media-sound/gsm"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-glibc28.patch
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-external-libgsm.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dobin src/vmo2gsm src/gsm2vmo src/vmo2wav
	einstalldocs
}
