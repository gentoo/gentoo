# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Plucene/Plucene-1.250.0-r1.ebuild,v 1.2 2015/06/13 22:39:43 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=TMTM
MODULE_VERSION=1.25
inherit perl-module

DESCRIPTION="Plucene - the Perl lucene port"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="virtual/perl-Memoize
		dev-perl/Tie-Array-Sorted
		dev-perl/Encode-compat
		dev-perl/File-Slurp
		dev-perl/Class-Virtual
		dev-perl/Class-Accessor
		virtual/perl-Time-Piece
		virtual/perl-File-Spec
		>=virtual/perl-Scalar-List-Utils-1.13
		dev-perl/Lingua-Stem
		dev-perl/Bit-Vector-Minimal
		dev-perl/IO-stringy"
DEPEND="${RDEPEND}
		>=virtual/perl-Test-Harness-2.30
		>=dev-perl/Module-Build-0.28"

SRC_TEST="do"
