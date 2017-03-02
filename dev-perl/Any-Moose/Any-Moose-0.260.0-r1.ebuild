# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.26
inherit perl-module

DESCRIPTION="Use Moose or Mouse modules (DEPRECATED)"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE="test"
PERL_RM_FILES=(
	"t/001-basic-mouse.t"
	"t/002-other-modules-mouse.t"
	"t/003-is_moose_loaded.t"
	"t/004-x-modules-mouse.t"
	"t/005-aliases-mouse.t"
	"t/010-use_mouse_roles.t"
	"t/012-use_mouse_util.t"
)
PATCHES=( "${FILESDIR}/nomouse.patch" )
RDEPEND="dev-perl/Moose
	virtual/perl-version"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.31
	test? (
		dev-perl/Moose
		dev-perl/MooseX-Types
	)
"
