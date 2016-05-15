# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MMIMS
DIST_VERSION=4.01010
inherit perl-module

DESCRIPTION="A perl interface to the Twitter API"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test examples"

RDEPEND="
	dev-perl/Carp-Clan
	dev-perl/Class-Load
	dev-perl/Data-Visitor
	>=dev-perl/DateTime-0.51
	dev-perl/DateTime-Format-Strptime
	>=dev-perl/Devel-StackTrace-1.21
	virtual/perl-Digest-SHA
	virtual/perl-Encode
	dev-perl/HTML-Parser
	dev-perl/HTTP-Message
	>=dev-perl/IO-Socket-SSL-2.5.0
	dev-perl/JSON
	dev-perl/LWP-Protocol-https
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Moose-0.940.0
	dev-perl/MooseX-Role-Parameterized
	dev-perl/Net-HTTP
	!=dev-perl/Net-HTTP-6.40.0
	!=dev-perl/Net-HTTP-6.50.0
	virtual/perl-libnet
	>=dev-perl/Net-OAuth-0.25
	virtual/perl-Time-HiRes
	>=dev-perl/Try-Tiny-0.30.0
	>=dev-perl/URI-1.400.0
	dev-perl/namespace-autoclean
"

DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	test? (
		virtual/perl-Carp
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		>=dev-perl/libwww-perl-5.819.0
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-Warn
	)
"
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto  /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
src_test() {
	perl_rm_files 't/99-pod_spelling.t' 't/release-pod-syntax.t' 't/release-pod-coverage.t'
	perl-module_src_test
}
