# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="A library of routines for managing a database"
HOMEPAGE="https://fallabs.com/tokyocabinet/"
SRC_URI="https://fallabs.com/tokyocabinet/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="bzip2 debug doc examples threads zlib"

DEPEND="
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/fix_rpath.patch" )

src_prepare() {
	default

	sed \
		-e "/ldconfig/d" \
		-e "/DATADIR/d" \
		-i Makefile.in || die

	# cflags fix - remove -O3 at end of line and -fomit-frame-pointer
	sed -i -e 's/-O3"$/"/' configure.in || die
	sed -i -e 's/-fomit-frame-pointer//' configure.in || die

	# flag only works on x86 derivatives, remove everywhere else
	if ! use x86 && ! use amd64; then
		sed -i -e 's/ -minline-all-stringops//' configure.in || die
	fi

	sed -e 's/libtokyocabinet.a/libtokyocabinet.so/g' -i configure.in || die

	AR="$(tc-getAR)"
	eautoreconf
}

src_configure() {
	# we use the "fastest" target without the -O3
	myconf=(
		--enable-off64
		--enable-fastest
		$(use_enable bzip2 bzip)
		$(use_enable debug)
		$(use_enable threads pthread)
		$(use_enable zlib)
	)

	econf "${myconf[@]}"
}

src_test() {
	emake -j1 check
}

src_install() {
	default

	use doc && dodoc -r doc/.
	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
