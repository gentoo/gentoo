# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=NEELY
DIST_VERSION=0.65
inherit perl-module

DESCRIPTION="Modules that serialize data structures"
# License note: "perl 5.8.2 or later"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-AutoLoader
	>=virtual/perl-Data-Dumper-2.80.0
	virtual/perl-Digest-SHA
	virtual/perl-Exporter
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	virtual/perl-File-Spec
	>=dev-perl/Module-Build-0.350.0
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	"t/00-01-Signature.t"
	"t/00-02-Kwalitee.t"
	"t/10-01-Pod.t"
	"t/10-02-Pod-Coverage.t"
)
# Parallelism broken: https://rt.cpan.org/Ticket/Display.html?id=123331
DIST_TEST="do"

src_test() {
	ewarn "Additional dependencies may need installation for comprehensive tests."
	ewarn "For details, see:"
	ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	perl-module_src_test
}
