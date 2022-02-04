# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TMTM
DIST_VERSION=v${PV}
DIST_WIKI="tests"
inherit perl-module

DESCRIPTION="Simple Database Abstraction"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86 ~x86-solaris"

RDEPEND="
	>=dev-perl/Class-Data-Inheritable-0.20.0
	>=dev-perl/Class-Accessor-0.18.0
	>=dev-perl/Class-Trigger-0.70.0
	>=virtual/perl-File-Temp-0.120.0
	virtual/perl-Storable
	>=virtual/perl-Scalar-List-Utils-1.80.0
	dev-perl/Clone
	>=dev-perl/Ima-DBI-0.330.0
	virtual/perl-version
	>=dev-perl/UNIVERSAL-moniker-0.60.0
"
BDEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"

src_test() {
	perl_rm_files t/97-pod.t
	perl-module_src_test
}
