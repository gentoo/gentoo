# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit toolchain-funcs versionator

MY_PV=$(delete_all_version_separators)

DESCRIPTION="CD EDC/ECC code (un)stripper"
HOMEPAGE="https://web.archive.org/web/20091104002036/www.neillcorlett.com/ecm"
SRC_URI="https://web.archive.org/web/20091021035854/www.neillcorlett.com/downloads/${PN}${MY_PV}.zip
         test? ( https://yegortimoshenko.s3.amazonaws.com/${PN}-test.bin )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~mips ~ppc ~ppc64 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	emake CC="$(tc-getCC)" -f - <<-'EOF'
	      all: ecm unecm
	EOF
}

src_test() {
	einfo "roundtripping ${PN}-test.bin (single M2F1 sector)"
	./ecm "${DISTDIR}/${PN}-test.bin" "${T}/${PN}-test.bin.ecm" || die "failed to strip"
	./unecm "${T}/${PN}-test.bin.ecm" || die "failed to unstrip"
	diff "${DISTDIR}/${PN}-test.bin" "${T}/${PN}-test.bin" || die "roundtrip failed"
}

src_install() {
	dobin {un,}ecm
	dodoc {format,readme}.txt
}
