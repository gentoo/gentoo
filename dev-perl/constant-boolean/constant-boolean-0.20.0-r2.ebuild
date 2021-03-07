# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DEXTER
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Define TRUE and FALSE constants"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Symbol-Util-0.20.0
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"
