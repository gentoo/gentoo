# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_AUTHOR=DANIEL
inherit perl-module

DESCRIPTION="An OO interface to Musepack file information and APE tag fields"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-perl/Audio-Scan-0.850.0"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

SRC_TEST="do parallel"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
