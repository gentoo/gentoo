# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-build multilib-minimal multilib toolchain-funcs

DESCRIPTION="Low-level cryptographic library"
HOMEPAGE="http://www.lysator.liu.se/~nisse/nettle/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="|| ( LGPL-3 LGPL-2.1 )"
SLOT="0/7" # subslot = libnettle soname version
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+asm doc +gmp static-libs test cpu_flags_x86_aes cpu_flags_arm_neon cpu_flags_x86_sha"
RESTRICT="!test? ( test )"

DEPEND="gmp? ( >=dev-libs/gmp-6.0:0=[static-libs?,${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/nettle/version.h
)

DOCS=()
HTML_DOCS=()

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

	# I do not see in config.sub reference to sunldsolaris.
	# if someone complains readd
	# -e 's/solaris\*)/sunldsolaris*)/' \
	sed -e '/CFLAGS=/s: -ggdb3::' \
		-i configure.ac || die

	eautoreconf
}

multilib_src_configure() {
	# --disable-openssl bug #427526
	ECONF_SOURCE="${S}" econf \
		$(tc-is-static-only && echo --disable-shared) \
		$(use_enable cpu_flags_x86_aes x86-aesni) \
		$(use_enable cpu_flags_x86_sha x86-sha-ni) \
		$(use_enable asm assembler)
		$(use_enable doc documentation) \
		$(use_enable gmp public-key) \
		$(use_enable cpu_flags_arm_neon arm-neon) \
		$(use_enable static-libs static) \
		--disable-fat \
		--disable-openssl \
		--libdir="${EPREFIX}"/usr/$(get_libdir)
}
