# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DSCHWEI
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="Parse::Syslog - Parse Unix syslog files"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ppc64 sparc x86"

RDEPEND="
	virtual/perl-Time-Local
	dev-perl/File-Tail
"

BDEPEND="${RDEPEND}
"
