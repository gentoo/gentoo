# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Primer Design for PCR reactions"
HOMEPAGE="http://primer3.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-buildsystem.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

src_prepare() {
	default
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -e "s:LIBOPTS ='-static':LIBOPTS =:" -i Makefile || die
	fi
}

src_configure() {
	tc-export AR CC CXX
}

src_compile() {
	emake -C src
}

src_test() {
	emake -C test | tee "${T}"/test.log
	grep -q "\[FAILED\]" && die "test failed. See ${T}/test.log"
}

src_install() {
	dobin src/{long_seq_tm_test,ntdpal,oligotm,primer3_core}

	insinto /opt/primer3_config
	doins -r src/primer3_config/. primer3*settings.txt

	dodoc src/release_notes.txt example
	docinto html
	dodoc primer3_manual.htm
}
