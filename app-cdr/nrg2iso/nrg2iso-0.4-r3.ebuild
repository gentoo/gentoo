# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Convert CD images from nrg (Nero) to iso"
HOMEPAGE="http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html"
SRC_URI="
	http://gregory.kokanosky.free.fr/v4/linux/${P}.tar.gz
	test? (
		https://yegortimoshenko.s3.amazonaws.com/${PN}-test.iso
		https://yegortimoshenko.s3.amazonaws.com/${PN}-test.nrg
	)"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	tc-export CC
}

src_compile() {
	emake nrg2iso
}

src_test() {
	einfo "checking that nrg -> iso matches the expected output"
	./nrg2iso "${DISTDIR}"/nrg2iso-test.nrg "${T}"/nrg2iso-test.iso || die "conversion failed"
	diff "${DISTDIR}"/nrg2iso-test.iso "${T}"/nrg2iso-test.iso || die "unexpected iso"
}

src_install() {
	dobin nrg2iso
	einstalldocs
}
