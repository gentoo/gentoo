# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=${PV%0.0}
DIST_AUTHOR=RATCLIFFE
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Access SANE-compatible scanners from Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Exception-Class
	dev-perl/Readonly
	>=media-gfx/sane-backends-1.0.19"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
	test? ( dev-perl/Test-Requires )"

PERL_RM_FILES=( t/{90_MANIFEST,91_critic,pod}.t )
