# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils flag-o-matic libtool ltprune multilib-minimal

DESCRIPTION="The Fast Lexical Analyzer"
HOMEPAGE="https://flex.sourceforge.net/ https://github.com/westes/flex"
SRC_URI="https://github.com/westes/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="FLEX"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls static test"
RESTRICT="!test? ( test )"

# We want bison explicitly and not yacc in general #381273
RDEPEND="sys-devel/m4"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	nls? ( sys-devel/gettext )
	test? ( sys-devel/bison )"

src_prepare() {
	#epatch "${PATCHES[@]}"
	epatch_user

	# Disable running in the tests/ subdir as it has a bunch of built sources
	# that cannot be made conditional (automake limitation). #568842
	if ! use test ; then
		sed -i \
			-e '/^SUBDIRS =/,/^$/{/tests/d}' \
			Makefile.in || die
	fi
	elibtoolize # Prefix always needs this
}

src_configure() {
	use static && append-ldflags -static

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# Do not install shared libs #503522
	ECONF_SOURCE=${S} \
	econf \
		--disable-shared \
		$(use_enable nls) \
		--docdir='$(datarootdir)/doc/'${PF}
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		cd src || die
		emake -f Makefile -f - lib <<< 'lib: $(lib_LTLIBRARIES)'
	fi
}

multilib_src_test() {
	multilib_is_native_abi && emake check
}

multilib_src_install() {
	if multilib_is_native_abi; then
		default
	else
		cd src || die
		emake DESTDIR="${D}" install-libLTLIBRARIES install-includeHEADERS
	fi
}

multilib_src_install_all() {
	einstalldocs
	dodoc ONEWS
	prune_libtool_files --all
	rm "${ED}"/usr/share/doc/${PF}/COPYING || die
	dosym flex /usr/bin/lex
}
