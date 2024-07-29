# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PHRED
DIST_VERSION=0.717
inherit perl-module

DESCRIPTION="client and server implementation of XML-RPC protocol"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/SOAP-Lite
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

# https://rt.cpan.org/Public/Bug/Display.html?id=127761
# fails "at random"
DIST_TEST=skip
