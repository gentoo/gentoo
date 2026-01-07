# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=VIPUL
DIST_VERSION=1.24
inherit perl-module

DESCRIPTION="Hashes (and objects based on hashes) with encrypting fields"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ~ppc x86"

RDEPEND="dev-perl/Crypt-Blowfish
	dev-perl/Crypt-DES
	dev-perl/Crypt-CBC"
BDEPEND="${RDEPEND}
"
