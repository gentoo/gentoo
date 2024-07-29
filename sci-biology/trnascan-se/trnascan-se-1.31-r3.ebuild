# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic perl-functions toolchain-funcs

DESCRIPTION="tRNA detection in large-scale genome sequences"
HOMEPAGE="http://lowelab.ucsc.edu/tRNAscan-SE/"
SRC_URI="http://lowelab.ucsc.edu/software/tRNAscan-SE.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/tRNAscan-SE-1.3.1/

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl:="
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-portable-perl-shebangs.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	tc-export CC
	append-cflags -std=gnu89 # mid-migration from K&R C, incompatible with c2x
}

src_test() {
	emake PATH="${S}:${PATH}" testrun
}

src_install() {
	dobin covels-SE coves-SE eufindtRNA tRNAscan-SE trnascan-1.4

	newman tRNAscan-SE.man tRNAscan-SE.man.1
	dodoc MANUAL Manual.ps README Release.history

	insinto /usr/share/trnascan-se
	doins *.cm gcode.* Dsignal TPCsignal

	perl_domodule -r tRNAscanSE
}
