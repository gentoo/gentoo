# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Primer Design for PCR reactions"
HOMEPAGE="http://primer3.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

DEPEND="dev-lang/perl"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.4-buildsystem.patch
	"${FILESDIR}"/${PN}-2.3.7-gcc7.patch
)

src_prepare() {
	default
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -e "s:LIBOPTS ='-static':LIBOPTS =:" -i Makefile || die
	fi
}

src_configure() {
	tc-export CC CXX AR RANLIB
}

src_compile() {
	emake -C src
}

src_test() {
	emake -C test | tee "${T}"/test.log
	grep -q "\[FAILED\]" && die "test failed. See "${T}"/test.log"
}

src_install() {
	dobin src/{long_seq_tm_test,ntdpal,oligotm,primer3_core}

	insinto /opt/primer3_config
	doins -r src/primer3_config/. primer3*settings.txt

	dodoc src/release_notes.txt example
	docinto html
	dodoc primer3_manual.htm
}
