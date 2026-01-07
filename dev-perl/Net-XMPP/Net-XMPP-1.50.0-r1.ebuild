# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAPATRICK
DIST_VERSION=1.05
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="XMPP Perl Library"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-perl/Authen-SASL-2.120.0
	virtual/perl-Digest-SHA
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-Stream-1.240.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.300
	test? (
		>=dev-perl/LWP-Online-1.70.0
		>=dev-perl/YAML-Tiny-1.410.0
		>=virtual/perl-Test-Simple-0.920.0
	)
"

PATCHES=(
	"${FILESDIR}/${DIST_VERSION}-no-network-tests.patch"
	"${FILESDIR}/${DIST_VERSION}-no-dot-inc.patch"
)
