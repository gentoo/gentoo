# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MAROS
DIST_VERSION=2.13
inherit perl-module

DESCRIPTION="Easily create plaintext/html e-mail messages with attachments and inline images"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# HTML::Tree -> HTML-TreeBuilder
# MIME::Tools -> MIME-tools
RDEPEND="
	dev-perl/Class-Load
	dev-perl/Email-Address
	dev-perl/Email-Date-Format
	>=dev-perl/Email-MessageID-1.400.0
	dev-perl/Email-Valid
	virtual/perl-Encode
	>=dev-perl/MIME-tools-5.400.0
	>=dev-perl/HTML-Tree-3.0.0
	dev-perl/MIME-Types
	>=dev-perl/Moose-0.940.0
	dev-perl/Path-Class
	dev-perl/Text-Table
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-Most
		dev-perl/Test-NoWarnings
	)
"
