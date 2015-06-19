# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CGI/CGI-3.650.0.ebuild,v 1.1 2015/06/13 12:27:42 dilfridge Exp $

EAPI=5

MY_PN=${PN}.pm
MODULE_AUTHOR=MARKSTOS
MODULE_VERSION=3.65
inherit perl-module

DESCRIPTION="Simple Common Gateway Interface Class"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

DEPEND="
	virtual/perl-File-Spec
	virtual/perl-if
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)
"
#	dev-perl/FCGI" #236921

SRC_TEST="do"
