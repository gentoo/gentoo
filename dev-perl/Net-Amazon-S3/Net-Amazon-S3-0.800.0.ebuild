# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RCONOVER
DIST_VERSION=0.80
inherit perl-module

DESCRIPTION="Framework for accessing the Amazon S3 Simple Storage Service"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Data-Stream-Bulk
	dev-perl/DateTime-Format-HTTP
	dev-perl/Digest-HMAC
	virtual/perl-Digest-MD5
	dev-perl/Digest-MD5-File
	dev-perl/File-Find-Rule
	virtual/perl-Getopt-Long
	dev-perl/HTTP-Date
	dev-perl/HTTP-Message
	virtual/perl-IO
	>=dev-perl/libwww-perl-6.30.0
	dev-perl/LWP-UserAgent-Determined
	virtual/perl-MIME-Base64
	dev-perl/MIME-Types
	>=dev-perl/Moose-0.850.0
	>=dev-perl/MooseX-StrictConstructor-0.160.0
	>=dev-perl/MooseX-Types-DateTime-MoreCoercions-0.70.0
	dev-perl/Path-Class
	dev-perl/Regexp-Common
	dev-perl/Term-Encoding
	dev-perl/Term-ProgressBar-Simple
	dev-perl/URI
	dev-perl/VM-EC2-Security-CredentialCache
	dev-perl/XML-LibXML

"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
