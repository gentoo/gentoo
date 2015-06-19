# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Date-Format/Email-Date-Format-1.2.0-r1.ebuild,v 1.1 2014/08/21 19:03:03 axs Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.002
inherit perl-module

DESCRIPTION="Produce RFC 822 date strings"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		>=dev-perl/Test-Pod-Coverage-1.0.8
	)"

SRC_TEST=do
