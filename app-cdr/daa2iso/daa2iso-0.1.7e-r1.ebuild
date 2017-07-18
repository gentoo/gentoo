# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit toolchain-funcs

DESCRIPTION="Convert CD images from daa/gbi to iso"
HOMEPAGE="http://aluigi.altervista.org/mytoolz.htm"
SRC_URI="http://aluigi.altervista.org/mytoolz/${PN}.zip -> ${P}.zip
         test? ( https://yegortimoshenko.s3.amazonaws.com/${PN}-test.daa
	       	 https://yegortimoshenko.s3.amazonaws.com/${PN}-test.gbi
                 https://yegortimoshenko.s3.amazonaws.com/${PN}-test.iso ) "

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	emake CC="$(tc-getCC)" -C src -f - <<-'EOF'
	      daa2iso: $(patsubst %.c,%.o,$(wildcard *.c))
	EOF
}

src_test() {
	for ext in daa gbi; do
	    einfo "checking that ${ext} -> iso matches the expected output"
	    src/${PN} "${DISTDIR}/${PN}-test.${ext}" "${T}/${PN}-${ext}.iso" # always returns 1
	    diff "${DISTDIR}/${PN}-test.iso" "${T}/${PN}-${ext}.iso" || die "unexpected iso"
	done
}

src_install() {
	dobin src/${PN}
	dodoc ${PN}.txt
}
