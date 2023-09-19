# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DEXTER
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Succeed or throw exception"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Exception-Died
	>=dev-perl/Exception-Base-0.22.01
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/Test-Unit-Lite-0.12
		dev-perl/Test-Assert
		dev-perl/Exception-Warning )
"
