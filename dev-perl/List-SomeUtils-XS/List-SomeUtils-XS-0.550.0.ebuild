# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.55
inherit perl-module

DESCRIPTION="XS implementation for List::SomeUtils"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Carp
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		virtual/perl-Storable
		dev-perl/Test-LeakTrace
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-Warnings-0.6.0
	)
"
