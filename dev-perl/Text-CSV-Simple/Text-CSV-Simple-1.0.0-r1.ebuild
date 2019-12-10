# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TMTM
MODULE_VERSION=1.00
inherit perl-module

DESCRIPTION="Text::CSV::Simple - Simpler parsing of CSV files"

SLOT="0"
LICENSE="|| ( GPL-3 GPL-2 )" # GPL-2+
KEYWORDS="amd64 ~arm ~mips ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Text-CSV_XS
	dev-perl/Class-Trigger
	dev-perl/File-Slurp"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
