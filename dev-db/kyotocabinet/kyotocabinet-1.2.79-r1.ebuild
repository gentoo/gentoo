# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="A straightforward implementation of DBM"
HOMEPAGE="https://dbmx.net/kyotocabinet/"
SRC_URI="https://dbmx.net/kyotocabinet/pkg/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug doc examples +lzma +lzo static-libs"

DEPEND="sys-libs/zlib[static-libs?]
	lzma? ( app-arch/xz-utils:=[static-libs?] )
	lzo? ( dev-libs/lzo:=[static-libs?] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix_configure-1.2.62.patch
	"${FILESDIR}"/${PN}-1.2.76-configure-8-byte-atomics.patch
	"${FILESDIR}"/${PN}-1.2.76-flags.patch
	"${FILESDIR}"/${PN}-1.2.79-configure-clang16.patch
)

src_prepare() {
	default

	sed -i -e "/DOCDIR/d" Makefile.in || die
	tc-export AR

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	# We need to set LD_LIBRARY_PATH which will be assigned to RUNENV later
	# used by test suite
	LD_LIBRARY_PATH=. \
	econf $(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable !static-libs shared) \
		$(use_enable lzma) \
		$(use_enable lzo)
}

src_test() {
	emake -j1 check
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die
	fi

	if use doc; then
		dodoc -r doc/*
	fi

	if use examples; then
		docinto example
		dodoc example/*
	fi
}
