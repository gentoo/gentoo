# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=VIPUL
MODULE_VERSION=1.25
inherit perl-module

DESCRIPTION="Cryptographically Secure, True Random Number Generator"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/Math-Pari-2.010603
	dev-perl/Class-Loader"
DEPEND="${RDEPEND}"

SRC_TEST="do"
