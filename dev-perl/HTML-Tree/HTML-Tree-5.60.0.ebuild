# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KENTNL
DIST_VERSION=5.06
inherit perl-module

DESCRIPTION="A library to manage HTML-Tree in PERL"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=dev-perl/HTML-Tagset-3.20.0
	>=dev-perl/HTML-Parser-3.460.0
	virtual/perl-Scalar-List-Utils
"
#	dev-perl/HTML-Format
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.800
	test? (
		virtual/perl-Encode
		dev-perl/Test-Fatal
		dev-perl/Test-LeakTrace
		virtual/perl-Test-Simple
		dev-perl/URI
	)
"
