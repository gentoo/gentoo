# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DANIEL
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Seamless DB schema up- and downgrades"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/File-Slurp
	virtual/perl-File-Spec
	dev-perl/DBI
	dev-perl/Class-Accessor
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.340.201
	test? (
		dev-perl/DBD-SQLite
	)
"
PERL_RM_FILES=(
	t/02pod.t
	t/03podcoverage.t
)
