# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs flag-o-matic

MY_P="${PN}${PV//.}"
DESCRIPTION="Info ZIP (encryption support)"
HOMEPAGE="http://www.info-zip.org/"
SRC_URI="mirror://sourceforge/infozip/${MY_P}.zip"
S="${WORKDIR}"/${MY_P}

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux"
IUSE="bzip2 crypt natspec unicode"

DEPEND="${RDEPEND}"
RDEPEND="bzip2? ( app-arch/bzip2 )
	natspec? ( dev-libs/libnatspec )"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-no-crypt.patch # bug #238398
	"${FILESDIR}"/${P}-pic.patch
	"${FILESDIR}"/${P}-exec-stack.patch # bug #122849
	"${FILESDIR}"/${P}-build.patch # bug #200995
	"${FILESDIR}"/${P}-zipnote-freeze.patch # bug #322047
	"${FILESDIR}"/${P}-format-security.patch # bug #512414
	"${FILESDIR}"/${P}-clang-15-configure-tests.patch
)

src_prepare() {
	# bug #275244
	use natspec && PATCHES+=( "${FILESDIR}"/${PN}-3.0-natspec.patch )
	default
}

src_configure() {
	append-cppflags \
		-DLARGE_FILE_SUPPORT \
		-DUIDGID_NOT_16BIT \
		-D$(usev !bzip2 'NO')BZIP2_SUPPORT \
		-D$(usev !crypt 'NO')CRYPT \
		-D$(usev !unicode 'NO')UNICODE_SUPPORT

	# - We use 'sh' because: 1. lacks +x bit, easier; 2. it tries to load bashdb
	# - Third arg disables bzip2 logic as we handle it ourselves above.
	edo sh ./unix/configure "$(tc-getCC)" "-I. -DUNIX ${CFLAGS} ${CPPFLAGS}" "${T}"

	if use bzip2 ; then
		sed -i -e "s:LFLAGS2=:&'-lbz2 ':" flags || die
	fi
}

src_compile() {
	emake \
		CPP="$(tc-getCPP)" \
		-f unix/Makefile generic
}

src_install() {
	dobin zip zipnote zipsplit
	doman man/zip{,note,split}.1
	if use crypt ; then
		dobin zipcloak
		doman man/zipcloak.1
	fi
	dodoc BUGS CHANGES README* TODO WHATSNEW WHERE proginfo/*.txt
}
