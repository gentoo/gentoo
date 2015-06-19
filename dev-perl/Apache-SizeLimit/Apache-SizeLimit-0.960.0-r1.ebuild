# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-SizeLimit/Apache-SizeLimit-0.960.0-r1.ebuild,v 1.2 2014/09/19 16:36:38 jer Exp $

EAPI=5

MODULE_AUTHOR=PHRED
MODULE_VERSION=0.96
inherit perl-module

DESCRIPTION="Graceful exit for large children"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE="test"

# mod_perl < 2.0.5 bundles Apache-SizeLimit
RDEPEND="dev-perl/Linux-Pid
	!<www-apache/mod_perl-2.0.5
	>=www-apache/mod_perl-2.0.5"
DEPEND="${RDEPEND}
	test? ( >=dev-perl/Apache-Test-1.360.0 )"

SRC_TEST="do"
