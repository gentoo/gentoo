# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ADAMK
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="Extremely light weight SQLite-specific schema migration"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Params-Util-0.370.0
	>=dev-perl/IPC-Run3-0.42.0
	>=virtual/perl-File-Path-2.04
	>=dev-perl/DBD-SQLite-1.210.0
	>=dev-perl/ORLite-1.280.0
	>=dev-perl/File-pushd-1.0.0
	>=dev-perl/Probe-Perl-0.10.0
	>=virtual/perl-File-Spec-3.270.100
	>=dev-perl/File-Which-1.70.0
	>=dev-perl/DBI-1.580.0
"
DEPEND="${RDEPEND}
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install::DSL/use lib q[.];\nuse inc::Module::Install::DSL/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
