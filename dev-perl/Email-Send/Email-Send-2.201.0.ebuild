# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Send/Email-Send-2.201.0.ebuild,v 1.2 2015/06/13 18:51:21 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=2.201
inherit perl-module

DESCRIPTION="Simply Sending Email"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

DEPEND="
	dev-perl/Email-Abstract
	>=dev-perl/Email-Address-1.800.0
	>=dev-perl/Email-Simple-1.920.0
	virtual/perl-File-Spec
	>=dev-perl/Module-Pluggable-2.970.0
	dev-perl/Return-Value
	>=virtual/perl-Scalar-List-Utils-1.20.0
"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		dev-perl/MIME-tools
		dev-perl/MailTools
		>=virtual/perl-Test-Simple-0.880.0
	)
"

SRC_TEST="do parallel"
