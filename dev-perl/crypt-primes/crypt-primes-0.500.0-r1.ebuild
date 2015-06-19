# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-primes/crypt-primes-0.500.0-r1.ebuild,v 1.1 2014/08/22 15:45:35 axs Exp $

EAPI=5

MY_PN=Crypt-Primes
MODULE_AUTHOR=VIPUL
MODULE_VERSION=0.50
inherit perl-module

DESCRIPTION="Provable Prime Number Generator suitable for Cryptographic Applications"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/math-pari
	dev-perl/crypt-random"
DEPEND="${RDEPEND}"

SRC_TEST="do"
