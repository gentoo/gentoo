# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJRAY
DIST_VERSION=0.80
DIST_EXAMPLES=( "ex/*.xpl" )
inherit perl-module

DESCRIPTION="An implementation of XML-RPC"

SLOT="0"
LICENSE="|| ( Artistic-2 LGPL-2.1 )"
KEYWORDS="amd64 ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-File-Spec-0.800.0
	>=dev-perl/libwww-perl-5.834.0
	>=virtual/perl-Module-Load-0.240.0
	>=virtual/perl-Scalar-List-Utils-1.200.0
	>=dev-perl/XML-LibXML-1.850.0
	>=dev-perl/XML-Parser-2.310.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.940.0 )
"

src_compile() {
	perl-module_src_compile
	if use examples; then
		pushd "${S}/ex" >/dev/null || die "Can't enter ${S}/ex"
		emake MAKEMETHOD="${S}/blib/script/make_method"
		popd >/dev/null || die "Can't exit ${S}/ex"
	fi
}
pkg_postinst() {
	SETWARN=0
	has_version '=www-servers/apache-2*' && HAVE_APACHE2=1
	has_version '>=www-apache/mod_perl-2.0' && HAVE_MP2=2

	[ -n "${HAVE_APACHE2}" ] && SETWARN=1
	[ -n "${HAVE_MP2}" ] && SETWARN=1

	if [ "${SETWARN}" == "1" ]; then
		ewarn "Apache2 or mod_perl2 were detected."
		ewarn ""
		ewarn "NOTE FROM THE AUTHOR OF RPC-XML"
		ewarn ""
		ewarn "At present, this package does not work with Apache2 and the soon-to-be"
		ewarn "mod_perl2. The changes to the API for location handlers are too drastic to"
		ewarn "try and support both within the same class (I tried, using the compatibility"
		ewarn "layer). Also, mp2 does not currently provide support for <Perl> sections, which"
		ewarn "are the real strength of the Apache::RPC::Server class."
	fi
}
