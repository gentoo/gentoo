# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SVW
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="Seamless DB schema up- and downgrades"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Class-Accessor
	>=dev-perl/DBI-1.330.0
	dev-perl/File-Slurp
	>=dev-perl/Log-Any-1.44.0
	dev-perl/Moo
	dev-perl/MooX-SetOnce
	dev-perl/MooX-StrictConstructor
	>=dev-perl/Path-Tiny-0.62.0
	dev-perl/PerlX-Maybe
	dev-perl/String-Expand
	dev-perl/Try-Tiny
	>=dev-perl/Type-Tiny-2.0.1
	dev-perl/Types-Path-Tiny
	dev-perl/Types-Self
	dev-perl/namespace-clean
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		dev-perl/DBD-Mock
		>=dev-perl/DBD-SQLite-1.600.0
		dev-perl/Test-API
		dev-perl/Test-DatabaseRow
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Output
		dev-perl/Test-Needs
	)
"

PERL_RM_FILES=(
	t/02pod.t
	t/03podcoverage.t
)
