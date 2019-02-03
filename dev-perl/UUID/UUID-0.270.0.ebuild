# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=JRM
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="Perl extension for using UUID interfaces as defined in e2fsprogs"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Note: UUID appears to link against a bunch of different UUID
# implementations depending on availability and platform.
#
# Presently uses uuid.h/libuuid.so from util-linux which is fine for Linux
# platforms, but may need special attention on *bsd, *osx and win*
RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Devel-CheckLib-1.20.0
"
