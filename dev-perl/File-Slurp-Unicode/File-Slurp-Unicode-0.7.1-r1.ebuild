# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DAVID
MODULE_VERSION=0.7.1
inherit perl-module

DESCRIPTION="Reading/Writing of Complete Files with Character Encoding Support"

SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	dev-perl/File-Slurp
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

SRC_TEST=do
