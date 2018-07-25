# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TMTM
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="Simple Database Abstraction"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86 ~x86-solaris"
IUSE="test"

RDEPEND=">=dev-perl/Class-Data-Inheritable-0.20.0
	>=dev-perl/Class-Accessor-0.18.0
	>=dev-perl/Class-Trigger-0.70.0
	>=virtual/perl-File-Temp-0.120.0
	virtual/perl-Storable
	>=virtual/perl-Scalar-List-Utils-1.80.0
	dev-perl/Clone
	>=dev-perl/Ima-DBI-0.330.0
	virtual/perl-version
	>=dev-perl/UNIVERSAL-moniker-0.60.0"
DEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"
src_test() {
	perl_rm_files t/97-pod.t
	ewarn "Testing this package comprehensively needs some manual interaction."
	ewarn "For details, see:"
	ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Class-DBI"
	perl-module_src_test
}
