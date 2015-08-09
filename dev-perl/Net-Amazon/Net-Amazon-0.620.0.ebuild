# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BOUMENOT
MODULE_VERSION=0.62
inherit perl-module

DESCRIPTION="Framework for accessing amazon.com via SOAP and XML/HTTP"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-perl/libwww-perl
	dev-perl/HTTP-Message
	>=dev-perl/XML-Simple-2.80.0
	>=virtual/perl-Time-HiRes-1.0.0
	>=dev-perl/Log-Log4perl-0.300.0
	virtual/perl-Digest-SHA
	dev-perl/URI
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
