# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ADAMK
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Parse and examine a Perl distribution MANIFEST file"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-perl/Params-Util-0.10
	>=virtual/perl-File-Spec-0.80
"
DEPEND="
	test? (	${RDEPEND}
		>=virtual/perl-Test-Simple-0.42
		>=dev-perl/Test-Exception-0.27
		>=dev-perl/Test-Warn-0.11
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install::DSL/use lib q[.];\nuse inc::Module::Install::DSL/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
