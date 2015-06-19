# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-MIME-Encodings/Email-MIME-Encodings-1.315.0-r1.ebuild,v 1.1 2014/08/22 20:56:44 axs Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.315
inherit perl-module

DESCRIPTION="A unified interface to MIME encoding and decoding"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND=">=virtual/perl-MIME-Base64-3.07"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/Capture-Tiny
	)"

SRC_TEST="do"
