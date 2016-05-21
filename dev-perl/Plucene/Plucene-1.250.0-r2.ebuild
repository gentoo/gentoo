# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TMTM
MODULE_VERSION=1.25
inherit perl-module

DESCRIPTION="Plucene - the Perl lucene port"

SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Bit-Vector-Minimal-1.0.0
	virtual/perl-Carp
	>=dev-perl/Class-Accessor-0.180.0
	>=dev-perl/Class-Virtual-0.30.0
	virtual/perl-Encode
	virtual/perl-File-Spec
	virtual/perl-IO
	dev-perl/Lingua-Stem
	>=virtual/perl-Scalar-List-Utils-1.130.0
	>=virtual/perl-Memoize-1.10.0
	>=dev-perl/Tie-Array-Sorted-1.100.0
	virtual/perl-Time-Piece
	dev-perl/Encode-compat
	dev-perl/File-Slurp
	dev-perl/IO-stringy
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? ( >=virtual/perl-Test-Harness-2.300.0 )
"

SRC_TEST="do"

PERL_RM_FILES=( t/99_pod.t )

src_install() {
	perl-module_src_install
	rm -rf "${ED}"/usr/bin
	rm -rf "${ED}"/usr/share/man
	insinto /usr/share/doc/${PF}/examples
	doins bin/*
	docompress -x /usr/share/doc/${PF}/examples
}
