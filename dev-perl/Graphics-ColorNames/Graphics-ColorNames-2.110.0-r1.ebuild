# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RRWO
MODULE_VERSION=2.11
inherit perl-module

DESCRIPTION="Defines RGB values for common color names"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="recommended"

COMMON_DEPEND="
	virtual/perl-File-Spec
	virtual/perl-IO
	>=virtual/perl-Module-Load-0.10
	virtual/perl-Module-Loaded
	recommended? (
		>=dev-perl/Color-Library-0.02
		dev-perl/Tie-Sub
		>=dev-perl/Pod-Readme-0.09
	)
"
DEPEND="
	${COMMON_DEPEND}
	dev-perl/Test-Exception
	virtual/perl-Test-Simple
	dev-perl/Module-Build
"
RDEPEND="
	${COMMON_DEPEND}
"
SRC_TEST="do"

src_test() {
	perl_rm_files t/90-pod-coverage.t t/90-pod.t \
		t/90-file-port.t
	perl-module_src_test
}
