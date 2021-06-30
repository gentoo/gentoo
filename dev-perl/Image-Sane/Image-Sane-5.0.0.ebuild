# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=5
DIST_AUTHOR=RATCLIFFE
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Access SANE-compatible scanners from Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Exception-Class
	dev-perl/Readonly
	>=media-gfx/sane-backends-1.0.19
"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
	test? (
		dev-perl/Test-Requires
		dev-perl/Try-Tiny
	)
"

PERL_RM_FILES=( t/{90_MANIFEST,91_critic,pod}.t )
