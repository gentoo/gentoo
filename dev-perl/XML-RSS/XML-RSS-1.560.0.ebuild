# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SHLOMIF
MODULE_VERSION=1.56
inherit perl-module

DESCRIPTION="a basic framework for creating and maintaining RSS files"
HOMEPAGE="http://perl-rss.sourceforge.net/"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-solaris"
IUSE="test"

SRC_TEST="do"

RDEPEND="dev-perl/HTML-Parser
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-W3CDTF
	>=dev-perl/XML-Parser-2.30"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )"
		#dev-perl/Test-Differences

PATCHES=(
	"${FILESDIR}/nomanifest.patch"
)

src_test() {
	perl_rm_files t/pod{,-coverage}.t t/cpan-changes.t t/style-trailing-space.t
	perl-module_src_test
}
