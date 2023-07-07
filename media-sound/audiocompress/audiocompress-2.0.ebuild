# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=AudioCompress-${PV}

DESCRIPTION="Very gentle 1-band dynamic range compressor"
HOMEPAGE="https://github.com/fluffy-critter/audiocompress"
SRC_URI="https://beesbuzz.biz/code/audiocompress/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)"
}

src_install() {
	dobin AudioCompress
	einstalldocs
}
