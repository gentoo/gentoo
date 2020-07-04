# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILMARI
DIST_VERSION=0.02003
inherit perl-module

DESCRIPTION="Auto-create NetAddr::IP objects from columns"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/NetAddr-IP
	>=dev-perl/DBIx-Class-0.81.70
"
DEPEND="${RDEPEND}
	test? ( dev-perl/DBD-SQLite )
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install /use lib q[.];\nuse inc::Module::Install /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t t/style-notabs.t
	perl-module_src_test
}
