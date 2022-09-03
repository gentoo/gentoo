# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/libtasn1.asc
inherit multilib-minimal libtool verify-sig

DESCRIPTION="ASN.1 library"
HOMEPAGE="https://www.gnu.org/software/libtasn1/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )"

LICENSE="LGPL-2.1+"
SLOT="0/6" # subslot = libtasn1 soname version
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs test valgrind"

RESTRICT="!test? ( test )"

BDEPEND="
	sys-apps/help2man
	virtual/yacc
	test? ( valgrind? ( dev-util/valgrind ) )
	verify-sig? ( sec-keys/openpgp-keys-libtasn1 )
"

DOCS=( AUTHORS ChangeLog NEWS README.md THANKS )

src_prepare() {
	default

	# For Solaris shared library
	elibtoolize
}

multilib_src_configure() {
	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer=no

	local myeconfargs=(
		$(use_enable static-libs static)
		$(multilib_native_use_enable valgrind valgrind-tests)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -type f -name '*.la' -delete || die
}
