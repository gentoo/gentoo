# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=XAOC
DIST_VERSION=1.16
inherit perl-module

DESCRIPTION="Simplistic perl interface to pkg-config"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
"
