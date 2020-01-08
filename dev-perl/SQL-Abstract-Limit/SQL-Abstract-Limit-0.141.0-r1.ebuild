# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DAVEBAIRD
MODULE_VERSION=0.141
inherit perl-module

DESCRIPTION="Portable LIMIT emulation"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/SQL-Abstract
	 dev-perl/DBI"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Deep
		dev-perl/Test-Exception
	)"

SRC_TEST=do
