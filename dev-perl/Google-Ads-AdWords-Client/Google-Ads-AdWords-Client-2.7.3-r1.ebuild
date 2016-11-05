# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="awapi_perl_lib"
MY_PV="${PV//\./_}"
MY_P="${MY_PN}_${MY_PV}"

inherit perl-module

S="${WORKDIR}/GOOGLE-ADWORDS-PERL-CLIENT-${PV}"

SRC_TEST="do"

# tests seem to be failing, contacted upstream.
# code has been tested to work on 2.6.0 though
RESTRICT="test"

DESCRIPTION="Google AdWords API Perl Client"
HOMEPAGE="https://github.com/googleads/googleads-perl-lib"
SRC_URI="https://google-api-adwords-perl.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-perl/Cache
	dev-perl/IO-Socket-SSL
	dev-perl/Log-Log4perl
	dev-perl/libwww-perl
	dev-perl/Math-Random-MT
	>=dev-perl/Net-OAuth-0.27
	>=dev-perl/SOAP-WSDL-2.00.10
	dev-perl/URI
	dev-perl/XML-Simple
	dev-perl/XML-XPath
	dev-perl/CHI"

DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-MockObject
		virtual/perl-Getopt-Long
		dev-perl/Config-Properties
		dev-perl/Data-Uniqid
	)
	dev-perl/Module-Build"
