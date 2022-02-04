# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=WYANT
MODULE_VERSION=0.003
inherit perl-module

DESCRIPTION="Manipulate Mac OS X clipboards/pasteboards"

SLOT="0"
KEYWORDS="~ppc-macos ~x64-macos"
IUSE=""

DEPEND="
	dev-perl/Module-Build
"
