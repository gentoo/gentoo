# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DRSTEVE
DIST_VERSION=0.28
DIST_A_EXT=tgz
inherit perl-module

DESCRIPTION="Unix-style, Variously Hashed Passwords"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-perl/Module-Install"
