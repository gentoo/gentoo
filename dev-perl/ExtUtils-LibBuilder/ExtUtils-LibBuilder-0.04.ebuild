# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="AMBS"
MODULE_SECTION="ExtUtils"

inherit perl-module

DESCRIPTION="A tool to build C libraries"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="virtual/perl-ExtUtils-CBuilder
	dev-perl/Module-Build
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	test? ( virtual/perl-Test-Simple )"
RDEPEND=""

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t t/manifest.t
	perl-module_src_test
}
