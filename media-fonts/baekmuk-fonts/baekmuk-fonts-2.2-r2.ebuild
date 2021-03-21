# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BDF_P="${P/fonts/bdf}"
TTF_P="${P/fonts/ttf}"
UNI_P="${PN/fonts/unicode-bdf}-20020418"
inherit font font-ebdftopcf

DESCRIPTION="Korean Baekmuk Font"
HOMEPAGE="https://kldp.net/baekmuk/"
SRC_URI="https://kldp.net/${PN/-*}/release/865-${BDF_P}.tar.gz -> ${BDF_P}.tar.gz
	https://kldp.net/${PN/-*}/release/865-${TTF_P}.tar.gz -> ${TTF_P}.tar.gz
	unicode? ( mirror://gentoo/${UNI_P}.tar.bz2 )"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="unicode"
RESTRICT="binchecks strip"

src_unpack() {
	unpack ${BDF_P}.tar.gz ${TTF_P}.tar.gz
	if use unicode; then
		cd ${BDF_P}/bdf || die
		unpack ${UNI_P}.tar.bz2
	fi
}

src_compile() {
	cd ${BDF_P}/bdf || die
	font-ebdftopcf_src_compile
}

src_install() {
	FONT_S="${S}"/${TTF_P}/ttf FONT_SUFFIX="ttf" font_src_install
	FONT_S="${S}"/${BDF_P}/bdf font_src_install
}
