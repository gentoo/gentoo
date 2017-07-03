# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="ADAMK"
DIST_VERSION="1.06"

inherit perl-module

DESCRIPTION="Cyclically insert into a Template from a sequence of values"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-perl/Params-Util-1.60.0
	>=dev-perl/Template-Toolkit-2.240.0
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
