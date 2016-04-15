# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_VERSION=0.11
DIST_AUTHOR=GFRANKS
inherit perl-module

DESCRIPTION="Override subroutines in a module for unit testing"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/SUPER
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? ( >=virtual/perl-Test-Simple-0.450.0 )
"
src_test() {
	perl_rm_files t/pod_coverage.t t/pod.t
	perl-module_src_test
}
