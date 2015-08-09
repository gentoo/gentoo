# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GENTOO_DEPEND_ON_PERL=no
PERL_EXPORT_PHASE_FUNCTIONS=no
PYTHON_COMPAT=( python2_7 )

inherit autotools perl-module python-r1 eutils

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Nagios/Icinga event broker module that allows quick/direct access to your status data"
HOMEPAGE="http://mathias-kettner.de/checkmk_livestatus.html"
SRC_URI="http://mathias-kettner.de/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples perl python test"

RDEPEND="perl? (
		dev-lang/perl:0
		virtual/perl-Digest-MD5:0
		virtual/perl-Scalar-List-Utils:0
		>=virtual/perl-Thread-Queue-2.11:0
		virtual/perl-Encode:0
		dev-perl/JSON-XS:0
	)"
DEPEND="${RDEPEND}
	perl? (
		dev-perl/Module-Install:0
		virtual/perl-ExtUtils-MakeMaker:0
		virtual/perl-File-Path:0
		virtual/perl-File-Spec:0
		virtual/perl-File-Temp:0
		test? (
			dev-perl/File-Copy-Recursive:0
			dev-perl/Test-Pod:0
			dev-perl/Test-Perl-Critic:0
			dev-perl/Test-Pod-Coverage:0
			dev-perl/Perl-Critic:0
			dev-perl/Perl-Critic-Policy-Dynamic-NoIndirect:0
			dev-perl/Perl-Critic-Deprecated:0
			dev-perl/Perl-Critic-Nits:0
		)
	)"

# For perl test
SRC_TEST="parallel"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Use system Module::Install instead, it will be copied to $S by
	# Module::install itself.
	rm -rf api/perl/inc

	if use perl; then
		perl-module_src_prepare
	fi

	epatch "${FILESDIR}/${P}-no-strip.diff"
	epatch "${FILESDIR}/${P}-test-RequireRcsKeywords.diff"

	# Script too old
	rm -f missing

	eautoreconf
}

src_configure() {
	econf

	if use perl; then
		cd api/perl/
		perl-module_src_configure
	fi
}

src_compile() {
	emake

	if use perl; then
		cd api/perl
		perl-module_src_compile
	fi
}

src_test() {
	if use perl; then
		cd api/perl

		export TEST_AUTHOR="Test Author"
		perl-module_src_test
	fi
}

src_install() {
	emake -C src/ DESTDIR="${ED}" install-binPROGRAMS install-data-local

	if use perl; then
		cd api/perl
		perl-module_src_install
		cd "${S}"

		if use examples; then
			docinto examples/
			dodoc api/perl/examples/dump.pl
		fi
	fi

	if use python; then
		python_foreach_impl python_domodule api/python/livestatus.py

		if use examples; then
			newdoc api/python/README README.python

			docinto examples/
			dodoc api/python/{example,example_multisite,make_nagvis_map}.py
		fi
	fi
}
