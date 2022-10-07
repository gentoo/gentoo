# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic libtool multilib-minimal toolchain-funcs

DESCRIPTION="The Fast Lexical Analyzer"
HOMEPAGE="https://github.com/westes/flex"
SRC_URI="https://github.com/westes/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="FLEX"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls static test"
RESTRICT="!test? ( test )"

# We want bison explicitly and not yacc in general, bug #381273
RDEPEND="sys-devel/m4"
BDEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	test? ( sys-devel/bison )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.4-libobjdir.patch
	"${FILESDIR}"/${PN}-2.6.4-fix-build-with-glibc2.6+.patch
)

src_prepare() {
	default

	# Disable running in the tests/ subdir as it has a bunch of built sources
	# that cannot be made conditional (automake limitation). bug #568842
	if ! use test ; then
		sed -i \
			-e '/^SUBDIRS =/,/^$/{/tests/d}' \
			Makefile.in || die
	fi

	# Prefix always needs this
	elibtoolize
}

src_configure() {
	use static && append-ldflags -static

	multilib-minimal_src_configure
}

multilib_src_configure() {
	if tc-is-cross-compiler ; then
		# Similar to workaround for procps:
		# - bug #705800
		# - https://sourceforge.net/p/psmisc/bugs/71/
		# - https://lists.gnu.org/archive/html/autoconf/2011-04/msg00019.html
		export ac_cv_func_malloc_0_nonnull=yes \
			ac_cv_func_realloc_0_nonnull=yes
	fi

	# Do not install shared libs, #503522
	ECONF_SOURCE="${S}" econf \
		CC_FOR_BUILD="$(tc-getBUILD_CC)" \
		--disable-shared \
		$(use_enable nls)
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake -C src -f Makefile -f - lib <<< 'lib: $(lib_LTLIBRARIES)'
	fi
}

multilib_src_test() {
	multilib_is_native_abi && emake check
}

multilib_src_install() {
	if multilib_is_native_abi; then
		default
	else
		emake -C src DESTDIR="${D}" install-libLTLIBRARIES install-includeHEADERS
	fi
}

multilib_src_install_all() {
	einstalldocs
	dodoc ONEWS
	find "${ED}" -name '*.la' -type f -delete || die
	rm "${ED}"/usr/share/doc/${PF}/COPYING || die

	dosym flex /usr/bin/lex
}
