# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Redis/Redis-1.961.0.ebuild,v 1.1 2014/10/25 18:46:25 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MELO
MODULE_VERSION=1.961
inherit perl-module

DESCRIPTION="Perl binding for the Redis database"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Digest-SHA
		dev-perl/IO-String
		virtual/perl-IPC-Cmd
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"
