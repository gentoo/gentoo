# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XMLRPC-Lite/XMLRPC-Lite-0.717.0.ebuild,v 1.1 2015/07/12 09:26:27 idl0r Exp $

EAPI=5

MODULE_AUTHOR="PHRED"
MODULE_VERSION=0.717
inherit perl-module

DESCRIPTION="client and server implementation of XML-RPC protocol"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/SOAP-Lite"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
