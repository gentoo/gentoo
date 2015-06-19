# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Module-Build-Tiny/Module-Build-Tiny-0.37.0.ebuild,v 1.2 2014/11/09 10:37:51 zlogene Exp $
EAPI=5
MODULE_AUTHOR=LEONT
MODULE_VERSION=0.037
inherit perl-module

DESCRIPTION='A tiny replacement for Module::Build'
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-CPAN-Meta
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/ExtUtils-Config-0.3.0
	>=dev-perl/ExtUtils-Helpers-0.20.0
	virtual/perl-ExtUtils-Install
	>=dev-perl/ExtUtils-InstallPaths-0.2.0
	virtual/perl-ExtUtils-ParseXS
	virtual/perl-File-Path
	virtual/perl-File-Spec
	>=virtual/perl-Getopt-Long-2.360.0
	>=virtual/perl-JSON-PP-2.0.0
	virtual/perl-podlators
	virtual/perl-Test-Harness
"

DEPEND="
	${RDEPEND}
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Temp
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.88
		virtual/perl-XSLoader
	)
"

SRC_TEST="do parallel"

mytargets="install"
