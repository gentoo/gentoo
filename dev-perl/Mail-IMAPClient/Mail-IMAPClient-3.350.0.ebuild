# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-IMAPClient/Mail-IMAPClient-3.350.0.ebuild,v 1.9 2014/03/19 20:53:06 zlogene Exp $

EAPI=5

MODULE_AUTHOR=PLOBBES
MODULE_VERSION=3.35
inherit perl-module

DESCRIPTION="IMAP client module for Perl"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Parse-RecDescent-1.940.0
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST="do"
