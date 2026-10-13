# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Primer Design for PCR reactions"
HOMEPAGE="http://primer3.sourceforge.net/"
SRC_URI="https://github.com/primer3-org/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-buildsystem.patch
)

src_prepare() {
	default
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -e "s:LIBOPTS ='-static':LIBOPTS =:" -i Makefile || die
	fi
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
	doins -r src/primer3_config/. settings_files/primer3*settings.txt

	dodoc src/release_notes.txt example
	docinto html
	dodoc src/primer3_manual.htm
}
