# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=3.003
DIST_AUTHOR=SWALTERS
inherit perl-module

DESCRIPTION="SOAP with WSDL support"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test examples"

RDEPEND="
	>=dev-perl/Class-Load-0.200.0
	>=dev-perl/Class-Std-Fast-0.0.5
	virtual/perl-Data-Dumper
	dev-perl/TimeDate
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	dev-perl/libwww-perl
	dev-perl/Module-Build
	virtual/perl-Scalar-List-Utils
	virtual/perl-Storable
	>=dev-perl/Template-Toolkit-2.180.0
	dev-perl/TermReadKey
	dev-perl/URI
	dev-perl/XML-Parser
"

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		virtual/perl-Getopt-Long
		virtual/perl-Storable
	)
"
DIST_TEST="do" # parallel testing dies
src_prepare() {
	perl-module_src_prepare
	perl_rm_files test_html.pl
}
src_test() {
	perl_rm_files t/098_pod.t t/099_pod_coverage.t t/094_cpan_meta.t t/095_copying.t t/096_characters.t t/097_kwalitee.t
	perl-module_src_test
}
src_install() {
	perl-module_src_install
	dodoc MIGRATING
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc -r example/*
	fi
}
