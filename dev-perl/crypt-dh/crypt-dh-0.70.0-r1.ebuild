# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-dh/crypt-dh-0.70.0-r1.ebuild,v 1.1 2014/08/22 15:00:14 axs Exp $

EAPI=5

MY_PN=Crypt-DH
MODULE_AUTHOR=MITHALDU
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Diffie-Hellman key exchange system"

SLOT="0"
KEYWORDS="amd64 hppa ~mips ~ppc x86"
IUSE=""

RDEPEND="
	dev-libs/gmp
	dev-perl/Math-BigInt-GMP
	>=virtual/perl-Math-BigInt-1.60
	dev-perl/crypt-random
"
DEPEND="${RDEPEND}"
