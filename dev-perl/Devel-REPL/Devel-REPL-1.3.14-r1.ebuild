# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-REPL/Devel-REPL-1.3.14-r1.ebuild,v 1.1 2014/08/26 19:13:48 axs Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.003014
inherit perl-module

DESCRIPTION="A modern perl interactive shell"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Moose-0.740.0
	>=dev-perl/MooseX-Object-Pluggable-0.0.9
	>=dev-perl/MooseX-Getopt-0.180.0
	dev-perl/namespace-autoclean
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	virtual/perl-Term-ANSIColor

	dev-perl/App-Nopaste
	dev-perl/B-Keywords
	dev-perl/Data-Dump-Streamer
	dev-perl/Data-Dumper-Concise
	dev-perl/File-Next
	dev-perl/Lexical-Persistence
	dev-perl/Module-Refresh
	dev-perl/PPI
	dev-perl/Sys-SigAction
"
# B::Concise? => perl
# Devel::Peek => perl
# Term::ReadLine => perl

DEPEND="${RDEPEND}"

SRC_TEST="do"
