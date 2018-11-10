# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
		dev-perl/Capture-Tiny
	)"

SRC_TEST="do"
