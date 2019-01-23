# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools toolchain-funcs

DESCRIPTION="A straightforward implementation of DBM"
HOMEPAGE="https://fallabs.com/kyotocabinet/"
SRC_URI="${HOMEPAGE}pkg/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="debug doc examples +lzma +lzo static-libs"

DEPEND="sys-libs/zlib[static-libs?]
	lzma? ( app-arch/xz-utils:=[static-libs?] )
	lzo? ( dev-libs/lzo:=[static-libs?] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/fix_configure-1.2.62.patch
	"${FILESDIR}"/${PN}-1.2.76-configure-8-byte-atomics.patch
	"${FILESDIR}"/${PN}-1.2.76-flags.patch
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

	if use examples; then
		insinto /usr/share/${PF}/example
		doins example/*
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/*
	fi
}
