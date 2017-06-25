# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BTROTT
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Syndication feed auto-discovery"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Class-ErrorHandler
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/URI
"
DEPEND="${RDEPEND}"

DIST_TEST=online

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
