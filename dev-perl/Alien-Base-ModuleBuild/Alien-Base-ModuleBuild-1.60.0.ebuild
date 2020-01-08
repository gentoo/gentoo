# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PLICEASE
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="A Module::Build subclass for building Alien:: modules and their libraries"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# HTML-Parser for HTML::LinkExtor
# Alien-Build for Alien::Base::PkgConfig
RDEPEND="
>=dev-perl/Alien-Build-1.200.0
>=dev-perl/Capture-Tiny-0.170.0
>=dev-perl/File-chdir-0.100.500
>=dev-perl/Module-Build-0.400.400
>=dev-perl/Path-Tiny-0.77.0
>=virtual/perl-Archive-Tar-1.400.0
>=virtual/perl-HTTP-Tiny-0.44.0
>=virtual/perl-Scalar-List-Utils-1.450.0
>=virtual/perl-Text-ParseWords-3.260.0
dev-perl/Archive-Extract
dev-perl/HTML-Parser
dev-perl/Shell-Config-Generate
dev-perl/Shell-Guess
dev-perl/Sort-Versions
dev-perl/URI
virtual/perl-JSON-PP
virtual/perl-parent
"

# Test2-Suite for Test2::Require::Module and Test2::V0
DEPEND="${RDEPEND}
	test? ( >=dev-perl/Test2-Suite-0.0.71 )
"
