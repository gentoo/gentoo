# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=JQUELIN
DIST_VERSION=3.000
inherit perl-module

DESCRIPTION="Tests to check your code against best practices"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Data-Section-0.4.0
	dev-perl/Dist-Zilla
	dev-perl/Moose
	dev-perl/Test-Perl-Critic
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Path
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.940.0
		virtual/perl-autodie
	)
"
src_test() {
	perl_rm_files t/release-*.t
	perl-module_src_test
}
