# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Proc-Daemon/Proc-Daemon-0.190.0.ebuild,v 1.1 2015/04/02 21:07:24 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=AKREAL
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Run Perl program as a daemon process"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? ( dev-perl/Proc-ProcessTable )
"

SRC_TEST="do"
