# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAPATRICK
DIST_VERSION=1.05
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="XMPP Perl Library"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/Authen-SASL-2.120.0
	virtual/perl-Digest-SHA
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-Stream-1.240.0
"
DEPEND="${RDEPEND}
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
