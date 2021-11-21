# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MBRADSHAW
DIST_VERSION=2.20210915
inherit perl-module

DESCRIPTION="Object Oriented Authentication-Results Headers"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/JSON
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Exception )
"
