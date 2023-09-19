# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SALVA
DIST_VERSION=0.83
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Net::OpenSSH, Perl wrapper for OpenSSH secure shell client"

SLOT="0"
KEYWORDS="amd64 ~hppa ~sparc x86"
IUSE="minimal"

RDEPEND="
	virtual/ssh
	dev-perl/IO-Tty
	!minimal? (
		dev-perl/Net-SSH-Any
		dev-perl/Net-SFTP-Foreign
	)
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
