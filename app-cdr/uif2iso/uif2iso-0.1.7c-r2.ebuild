# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Convert CD images from uif (MagicISO) to iso"
HOMEPAGE="https://aluigi.altervista.org/mytoolz.htm#uif2iso"
SRC_URI="
	mirror://gentoo/${P}.zip
	test? (
		https://yegortimoshenko.s3.amazonaws.com/${PN}-test.iso
		https://yegortimoshenko.s3.amazonaws.com/${PN}-test.uif
	)"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	# https://bugs.gentoo.org/943915
	"${FILESDIR}"/${PN}-0.1.7c-fix_c23.patch
)

src_compile() {
	emake CC="$(tc-getCC)" -C src -f - <<- 'EOF'
		CPPFLAGS += -DMAGICISO_IS_SHIT
		LDLIBS = -lz
		uif2iso: $(patsubst %.c,%.o,$(wildcard *.c))
	EOF
}

src_test() {
	einfo "checking that uif -> iso matches the expected output"
	src/uif2iso "${DISTDIR}"/uif2iso-test.uif "${T}"/uif2iso-test.iso # always returns 1
	diff "${DISTDIR}"/uif2iso-test.iso "${T}"/uif2iso-test.iso || die "unexpected iso"
}

src_install() {
	dobin src/uif2iso
	dodoc uif2iso.txt README
}
