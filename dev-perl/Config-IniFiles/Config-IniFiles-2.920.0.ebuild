# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.92
inherit perl-module

DESCRIPTION="A module for reading .ini-style configuration files"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

# needs List::Util and Scalar::Util
RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Temp
	dev-perl/IO-stringy
	>=virtual/perl-Scalar-List-Utils-1.330.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t       \
			t/author-{pod-syntax,pod-coverage}.t \
			t/release-{cpan-changes,kwalitee}.t  \
			t/cpan-changes.t t/style-trailing-space.t
	perl-module_src_test
}
