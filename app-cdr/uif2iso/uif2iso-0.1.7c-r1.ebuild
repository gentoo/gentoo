# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit toolchain-funcs

DESCRIPTION="Convert CD images from uif (MagicISO) to iso"
HOMEPAGE="http://aluigi.altervista.org/mytoolz.htm#uif2iso"
SRC_URI="mirror://gentoo/${P}.zip
	 test? ( https://yegortimoshenko.s3.amazonaws.com/${PN}-test.iso
	       	 https://yegortimoshenko.s3.amazonaws.com/${PN}-test.uif )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	emake CC="$(tc-getCC)" -C src -f - <<-'EOF'
	      CPPFLAGS += -DMAGICISO_IS_SHIT
	      LDLIBS = -lz
	      uif2iso: $(patsubst %.c,%.o,$(wildcard *.c))
	EOF
}

src_test() {
	einfo "checking that uif -> iso matches the expected output"
	src/${PN} "${DISTDIR}/${PN}-test.uif" "${T}/${PN}-test.iso" # always returns 1
	diff "${DISTDIR}/${PN}-test.iso" "${T}/${PN}-test.iso" || die "unexpected iso"
}

src_install() {
	dobin src/${PN}
	dodoc ${PN}.txt README
}
