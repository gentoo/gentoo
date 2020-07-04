# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEELY
DIST_VERSION=0.60
inherit perl-module

DESCRIPTION="Modules that serialize data structures"
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-AutoLoader
	virtual/perl-Data-Dumper
	virtual/perl-Digest-SHA
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-File-Spec
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"
# Parallelism broken: https://rt.cpan.org/Ticket/Display.html?id=123331
DIST_TEST="do"

src_test() {
	ewarn "Additional dependencies may need installation for comprehensive tests."
	ewarn "For details, see:"
	ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Data-Serializer"
	perl-module_src_test
}
