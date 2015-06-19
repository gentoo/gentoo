# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Redis/Redis-1.976.0.ebuild,v 1.1 2014/12/11 23:59:48 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DAMS
MODULE_VERSION=1.976
inherit perl-module

DESCRIPTION="Perl binding for Redis database"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/IO-Socket-Timeout-0.220.0
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.36.0
	test? (
		virtual/perl-Digest-SHA
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/IO-String
		virtual/perl-IPC-Cmd
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-SharedFork
		>=dev-perl/Test-TCP-1.190.0
	)
"

mytargets="install"
