# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SALVA
DIST_VERSION=0.70
inherit perl-module

DESCRIPTION="Net::OpenSSH, Perl wrapper for OpenSSH secure shell client"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="
	virtual/ssh
	dev-perl/IO-Tty
	!minimal? (
		dev-perl/Net-SSH-Any
		dev-perl/Net-SFTP-Foreign
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
