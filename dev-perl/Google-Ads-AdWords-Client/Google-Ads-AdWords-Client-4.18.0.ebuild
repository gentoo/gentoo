# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=SUNDQUIST
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Google AdWords API Perl Client Library"
HOMEPAGE="https://github.com/googleads/googleads-perl-lib"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
PATCHES=(
	"${FILESDIR}/4.14.0-no-dot-in-inc.patch"
	"${FILESDIR}/4.14.0-unescaped-lbracket.patch"
)
RDEPEND="
	dev-perl/Class-Load
	>=dev-perl/Class-Std-Fast-0.0.5
	dev-perl/Crypt-OpenSSL-RSA
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	dev-perl/IO-Socket-SSL
	dev-perl/JSON-Parse
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/Log-Log4perl
	>=dev-perl/SOAP-WSDL-2.00.10
	virtual/perl-Scalar-List-Utils
	dev-perl/Template-Toolkit
	dev-perl/URI
	dev-perl/XML-Simple
	dev-perl/XML-XPath
	examples? (
		virtual/perl-Digest-SHA
		virtual/perl-File-Temp
		dev-perl/HTTP-Server-Simple
	)
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? (
		dev-perl/Config-Properties
		dev-perl/Data-Uniqid
		virtual/perl-File-Temp
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		dev-perl/Test-MockObject
		virtual/perl-Test-Simple
	)
"
