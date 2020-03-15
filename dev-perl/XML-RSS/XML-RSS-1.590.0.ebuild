# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.59
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="a basic framework for creating and maintaining RSS files"
HOMEPAGE="http://perl-rss.sourceforge.net/"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/DateTime
	dev-perl/HTML-Parser
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-W3CDTF
	>=dev-perl/XML-Parser-2.230.0"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	test? ( virtual/perl-Test-Simple )
"

PATCHES=(
	"${FILESDIR}/nomanifest.patch"
)

src_test() {
	perl_rm_files  t/pod{,-coverage}.t t/cpan-changes.t t/style-trailing-space.t
	perl-module_src_test
}
