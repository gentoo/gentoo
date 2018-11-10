# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CADE
MODULE_VERSION=1.8
inherit perl-module

DESCRIPTION="Patches text with given patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

RDEPEND="
	dev-perl/Text-Diff
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
