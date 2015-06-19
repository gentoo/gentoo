# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-WSDL/SOAP-WSDL-3.2.0.ebuild,v 1.2 2015/06/13 22:22:23 dilfridge Exp $

EAPI=5

MODULE_VERSION=v3.002
MODULE_AUTHOR=SWALTERS
inherit perl-module

DESCRIPTION="SOAP with WSDL support"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-Load-0.200.0
	>=dev-perl/Class-Std-Fast-0.0.5
	virtual/perl-Data-Dumper
	dev-perl/TimeDate
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	dev-perl/libwww-perl
	virtual/perl-Scalar-List-Utils
	dev-perl/Module-Build
	virtual/perl-Storable
	>=dev-perl/Template-Toolkit-2.180.0
	dev-perl/TermReadKey
	dev-perl/URI
	dev-perl/XML-Parser
"

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		virtual/perl-Getopt-Long
		virtual/perl-Storable
	)
"

SRC_TEST="do"
