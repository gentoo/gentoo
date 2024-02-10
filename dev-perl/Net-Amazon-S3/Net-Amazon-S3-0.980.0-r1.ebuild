# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BARNEY
DIST_VERSION=0.98
inherit perl-module

DESCRIPTION="Framework for accessing the Amazon S3 Simple Storage Service"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

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
	dev-perl/Safe-Isa
	dev-perl/Term-Encoding
	dev-perl/Term-ProgressBar-Simple
	virtual/perl-Time-Piece
	dev-perl/URI
	dev-perl/VM-EC2-Security-CredentialCache
	dev-perl/XML-LibXML
	dev-perl/namespace-clean
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		>=dev-perl/Test-Deep-0.111.0
		dev-perl/Test-Exception
		dev-perl/Test-MockTime
		dev-perl/Test-Warnings
		virtual/perl-Test-Simple
	)
"
