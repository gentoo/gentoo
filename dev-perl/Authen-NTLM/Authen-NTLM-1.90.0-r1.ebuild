# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=NTLM
MODULE_AUTHOR=NBEBOUT
MODULE_VERSION=1.09
inherit perl-module

DESCRIPTION="An NTLM authentication module"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~ppc x86"
IUSE="test"

RDEPEND=">=virtual/perl-MIME-Base64-3.00
	dev-perl/Digest-HMAC"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)"

SRC_TEST=do
export OPTIMIZE="$CFLAGS"
