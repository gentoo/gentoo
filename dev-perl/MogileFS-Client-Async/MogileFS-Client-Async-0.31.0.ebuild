# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DLAMBLEY
DIST_VERSION=0.031
inherit perl-module

DESCRIPTION="MogileFS Client using AnyEvent non-blocking IO"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/AnyEvent-HTTP
	dev-perl/File-Slurp
	dev-perl/IO-AIO
	dev-perl/libwww-perl
	>=dev-perl/Linux-PipeMagic-0.30.0
	>=dev-perl/MogileFS-Client-1.160.0
	dev-perl/Try-Tiny
	dev-perl/namespace-clean
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"

# Tests only available if you have a local mogilefsd on 127.0.0.1:7001
DIST_TEST=skip
