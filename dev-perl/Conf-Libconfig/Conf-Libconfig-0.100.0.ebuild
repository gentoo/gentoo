# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="CNANGEL"
DIST_VERSION="0.100"

inherit perl-module

DESCRIPTION="Perl extension for libconfig"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-libs/libconfig
	virtual/perl-XSLoader"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-PkgConfig
	test? (
		dev-perl/Test-Pod
		>=dev-perl/Test-Exception-0.430.0
		>=dev-perl/Test-Deep-1.127.0
		>=dev-perl/Test-Warn-0.320.0
	)"
