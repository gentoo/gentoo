# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.003
inherit perl-module

DESCRIPTION="Deconstructed Dynamic C Library Loading"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
