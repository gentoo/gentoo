# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/oath-toolkit.asc
inherit libtool pam verify-sig

DESCRIPTION="Toolkit for using one-time password authentication with HOTP/TOTP algorithms"
HOMEPAGE="https://oath-toolkit.codeberg.page/"
SRC_URI="
	https://codeberg.org/oath-toolkit/oath-toolkit/releases/download/v${PV}/${P}.tar.gz
	mirror://nongnu/${PN}/${P}.tar.gz
	verify-sig? (
		https://codeberg.org/oath-toolkit/oath-toolkit/releases/download/v${PV}/${P}.tar.gz.sig
		mirror://nongnu/${PN}/${P}.tar.gz.sig
	)
"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="pam static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libxml2:=
	dev-libs/xmlsec:=
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/gtk-doc-am
	test? ( dev-libs/libxml2 )
	verify-sig? ( sec-keys/openpgp-keys-oath-toolkit )
"

# fpurge is from gnulib, and unused as of 2.6.11
QA_CONFIG_IMPL_DECL_SKIP=(
	MIN # glibc fp
	alignof
	fpurge
	static_assert
	unreachable
)

src_prepare() {
	default

	elibtoolize

	# upstream has a gdoc.mk, which declares that Makefile.am -> Makefile.in has a rebuild rule on:
	#    $(top_builddir)/configure
	# which is baffling and also totally breaks elibtoolize. Munge the timestamps into forgetting about this.
	#touch */man/Makefile.gdoc */man/Makefile.in || die

	# After patching, we have to fix the mtime on libpskc/global.c so
	# that it doesn't cause Makefile.gdoc to be rebuilt so that it
	# doesn't cause Makefile.in to be rebuilt so that it doesn't try to
	# run automake-1.16.5 for no reason. Bug 936309.
	touch --reference=libpskc/errors.c libpskc/global.c || die
}

src_configure() {
	local myeconfargs=(
		--cache-file="${S}"/config.cache
		--enable-pskc
		--disable-valgrind-tests
		$(use_enable test xmltest)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# Without -k, it will bail out after the first testsuite failure,
	# skipping the other testsuites. as they are mostly independent, this sucks.
	emake -k check

	# Avoid errant QA notice for no tests run on these
	rm -f libpskc/gtk-doc/test-suite.log liboath/gtk-doc/test-suite.log || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die

	if use pam; then
		newdoc pam_oath/README README.pam
	fi

	doman pskctool/pskctool.1
}
