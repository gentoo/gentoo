# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JTK
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Perl port of Crypto-PAn to provide anonymous IP addresses"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	>=dev-perl/Crypt-Rijndael-0.40.0
"
BDEPEND="${RDEPEND}
"
