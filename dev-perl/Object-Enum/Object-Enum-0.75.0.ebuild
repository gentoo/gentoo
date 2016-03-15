# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=JMMILLS
DIST_VERSION=0.075
inherit perl-module

DESCRIPTION="Replacement for if (\$foo eq 'bar')"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Sub-Install
	dev-perl/Sub-Exporter
	dev-perl/Class-Data-Inheritable
	dev-perl/Class-Accessor"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files "t/pod.t" "t/pod-coverage.t" "t/boilerplate.t"
	perl-module_src_test
}
