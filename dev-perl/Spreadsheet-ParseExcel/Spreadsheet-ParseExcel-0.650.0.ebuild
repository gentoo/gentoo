# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DOUGW
MODULE_VERSION=0.65
inherit perl-module

DESCRIPTION="Read information from an Excel file"

SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="test cjk unicode"

# Digest::Perl::MD5 cannot be replaced by Digest::MD5, as this module actually
# interacts with the internal state of Digest::Perl::MD5.
RDEPEND="
	>=dev-perl/OLE-StorageLite-0.19
	dev-perl/IO-stringy
	dev-perl/Text-CSV_XS
	dev-perl/Crypt-RC4
	dev-perl/Digest-Perl-MD5
	unicode? ( dev-perl/Unicode-Map )
	cjk? ( dev-perl/Jcode )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Pod
		dev-perl/Unicode-Map
		dev-perl/Spreadsheet-WriteExcel
		dev-perl/Jcode
	)
"

SRC_TEST="do"
