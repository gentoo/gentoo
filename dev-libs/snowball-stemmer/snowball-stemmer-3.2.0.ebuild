# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a edo toolchain-funcs

MY_TESTDATA_COMMIT="019921c3a41c2b70063ee3feb215a00c8e594597"
DESCRIPTION="Snowball compiler and stemming algorithms"
HOMEPAGE="https://snowballstem.org/ https://github.com/snowballstem/snowball/"
SRC_URI="
	https://github.com/snowballstem/snowball/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
	test? ( https://github.com/snowballstem/snowball-data/archive/${MY_TESTDATA_COMMIT}.tar.gz
		-> snowball-data-${MY_TESTDATA_COMMIT}.tar.gz )
"
S="${WORKDIR}/snowball-${PV}"

LICENSE="BSD"
SONAME="3.1"
SLOT="0/${SONAME}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-lang/perl
	test? ( virtual/libiconv )
"

PATCHES=(
	# Shared-library: export only public sb_stemmer_* symbols (matching libstemmer.h)
	"${FILESDIR}"/${PN}-3.1.0-public_symbols.patch
)

src_configure() {
	use static-libs && lto-guarantee-fat
	default
}

src_compile() {
	# 947412
	tc-is-cross-compiler && tc-env_build emake snowball

	tc-export CC AR
	emake CFLAGS="${CFLAGS} -fPIC" all

	# upstream has historycally not provided the shared library, mainly due to the large number of relocation,
	# see https://github.com/snowballstem/snowball/issues/34
	# SO support depends on the build system changes, see https://github.com/snowballstem/snowball/issues/225
	edo "${CC}" \
		${CFLAGS} \
		${LDFLAGS} \
		-Wl,-version-script,libstemmer/symbol.map \
		-Wl,--whole-archive \
		libstemmer.a \
		-Wl,--no-whole-archive \
		-Wl,-soname,libstemmer.so.${SONAME} \
		-shared \
		-o libstemmer.so.${PV}
}

src_test() {
	emake -j1 STEMMING_DATA="${WORKDIR}/snowball-data-${MY_TESTDATA_COMMIT}" check
}

src_install() {
	dodoc README.rst NEWS

	dobin stemwords

	doheader include/libstemmer.h

	dolib.so libstemmer.so.${PV}
	dosym libstemmer.so.${PV} /usr/$(get_libdir)/libstemmer.so.${SONAME}
	dosym libstemmer.so.${PV} /usr/$(get_libdir)/libstemmer.so

	if use static-libs; then
		dolib.a libstemmer.a
		strip-lto-bytecode
	fi
}
