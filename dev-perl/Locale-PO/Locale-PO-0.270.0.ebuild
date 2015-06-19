# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Locale-PO/Locale-PO-0.270.0.ebuild,v 1.1 2015/04/01 22:38:18 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=COSIMO
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="Perl module for manipulating .po entries from GNU gettext"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

RDEPEND="
	sys-devel/gettext
	dev-perl/File-Slurp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
