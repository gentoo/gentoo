# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-build multilib-minimal multilib toolchain-funcs

DESCRIPTION="Low-level cryptographic library"
HOMEPAGE="http://www.lysator.liu.se/~nisse/nettle/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="|| ( LGPL-3 LGPL-2.1 )"
SLOT="0/6.2" # subslot = libnettle soname version, .2 as broke ABI bug#601512 then fixed
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +gmp neon static-libs test cpu_flags_x86_aes"
RESTRICT="!test? ( test )"

DEPEND="gmp? ( >=dev-libs/gmp-6.0:0=[static-libs?,${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/nettle/nettle-stdint.h
	/usr/include/nettle/version.h
)

DOCS=()
HTML_DOCS=()

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

pkg_setup() {
	use doc && DOCS+=(
		nettle.pdf
	)
	use doc && HTML_DOCS+=(
		nettle.html
	)
}

src_prepare() {
	default

	sed -e '/CFLAGS=/s: -ggdb3::' \
		-e 's/solaris\*)/sunldsolaris*)/' \
		-i configure.ac || die

	# conditionally build tests and examples required by tests
	use test || sed -i '/SUBDIRS/s/testsuite examples//' Makefile.in || die

	eautoreconf
}

multilib_src_configure() {
	# --disable-openssl bug #427526
	ECONF_SOURCE="${S}" econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-openssl \
		--disable-fat \
		$(use_enable gmp public-key) \
		$(use_enable static-libs static) \
		$(tc-is-static-only && echo --disable-shared) \
		$(use_enable doc documentation) \
		$(use_enable neon arm-neon) \
		$(use_enable cpu_flags_x86_aes x86-aesni)
}
