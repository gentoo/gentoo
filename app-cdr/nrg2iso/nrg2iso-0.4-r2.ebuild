# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="Convert CD images from nrg (Nero) to iso"
HOMEPAGE="http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html"
SRC_URI="http://gregory.kokanosky.free.fr/v4/linux/${P}.tar.gz
	test? (
		https://yegortimoshenko.s3.amazonaws.com/${PN}-test.iso
		https://yegortimoshenko.s3.amazonaws.com/${PN}-test.nrg
	)"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"
DOCS=( CHANGELOG )

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} ${PN}.c -o ${PN}
}

src_test() {
	einfo "checking that nrg -> iso matches the expected output"
	"${S}/${PN}" "${DISTDIR}/${PN}-test.nrg" "${T}/${PN}-test.iso" || die "conversion failed"
	diff "${DISTDIR}/${PN}-test.iso" "${T}/${PN}-test.iso" || die "unexpected iso"
}

src_install() {
	dobin ${PN}
	einstalldocs
}
