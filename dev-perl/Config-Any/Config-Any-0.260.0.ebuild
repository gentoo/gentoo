# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=0.26
inherit perl-module

DESCRIPTION="Load configuration from different file formats, transparently"

SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	>=dev-perl/Module-Pluggable-3.10.0
	!<dev-perl/config-general-2.47
	!<dev-perl/Config-General-2.47
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
