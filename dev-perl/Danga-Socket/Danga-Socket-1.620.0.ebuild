# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=NML
DIST_VERSION=1.62
inherit perl-module

DESCRIPTION="A non-blocking socket object; uses epoll()"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-IO
	virtual/perl-Socket
	dev-perl/Sys-Syscall
	virtual/perl-Time-HiRes
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-TCP
		virtual/perl-Test-Simple
	)
"
