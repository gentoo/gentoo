# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CWEST
MODULE_VERSION=2.05
inherit perl-module

DESCRIPTION="Convert plain text to HTML"

SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc x86"
IUSE=""

DEPEND="dev-perl/HTML-Parser
	virtual/perl-Test-Simple
	dev-perl/Exporter-Lite
	>=virtual/perl-Scalar-List-Utils-1.14
	dev-perl/Email-Find"
RDEPEND="${DEPEND}"

#SRC_TEST="do"
