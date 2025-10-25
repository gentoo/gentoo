# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Three dimensional inductance computation program, Whiteley Research version"
HOMEPAGE="http://www.wrcad.com/freestuff.html"
SRC_URI="http://www.wrcad.com/ftp/pub/fasthenry-$(ver_cut 1-2)wr-$(ver_cut 4)$(ver_cut 5)$(ver_cut 3).tar.gz"
S=${WORKDIR}/fasthenry-3.0wr

LICENSE="all-rights-reserved"
SLOT="0"

KEYWORDS="~amd64"
IUSE="cpu_flags_x86_avx"
RESTRICT="mirror bindist"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.20.07.17-ar.patch"
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-cflags.patch"
)

src_compile() {
	tc-export CC AR
	emake HAVX=$(usex cpu_flags_x86_avx 1 0) all
}

src_install() {
	dobin bin/fasthenry
	dobin bin/zbuf
	dodoc -r doc/*
	dodoc -r examples
}
