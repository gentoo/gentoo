# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIKEM
DIST_VERSION=1.81
DIST_EXAMPLES=("examples/*")
inherit multilib perl-module

DESCRIPTION="Perl extension for using OpenSSL"

LICENSE="openssl"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libressl test minimal examples"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	virtual/perl-MIME-Base64
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			dev-perl/Test-Exception
			dev-perl/Test-Warn
			dev-perl/Test-NoWarnings
		)
		virtual/perl-Test-Simple
	)
"
export OPTIMIZE="$CFLAGS"
export OPENSSL_PREFIX=${EPREFIX}/usr

src_prepare() {
	sed -i \
		-e "/\$opts->{optimize} = '-O2 -g';/d" \
		-e "s,\"\$prefix/lib\",\"\$prefix/$(get_libdir)\"," \
		inc/Module/Install/PRIVATE/Net/SSLeay.pm || die

	local my_test_control
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}

	if use test; then
		perl_rm_files 't/local/01_pod.t' 't/local/02_pod_coverage.t' 't/local/kwalitee.t'
	fi
	if use test && has network ${my_test_control} ; then
		eapply "${FILESDIR}/1.72-config-nettest-yes.patch"
	else
		eapply "${FILESDIR}/1.72-config-nettest-no.patch"
	fi

	perl-module_src_prepare
}
