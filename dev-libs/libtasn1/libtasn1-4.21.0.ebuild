# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libtasn1.asc
inherit multilib-minimal libtool verify-sig

DESCRIPTION="ASN.1 library"
HOMEPAGE="https://www.gnu.org/software/libtasn1/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )"

LICENSE="LGPL-2.1+ GPL-3+ FDL-1.3+"
SLOT="0/6" # subslot = libtasn1 soname version
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

BDEPEND="
	sys-apps/help2man
	app-alternatives/yacc
	verify-sig? ( >=sec-keys/openpgp-keys-libtasn1-20260112 )
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
		--disable-valgrind-tests
		$(use_enable static-libs static)
	)

	# https://gitlab.com/gnutls/libtasn1/-/issues/57 (bug #968661)
	export MAKEINFO=:
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -type f -name '*.la' -delete || die
}
