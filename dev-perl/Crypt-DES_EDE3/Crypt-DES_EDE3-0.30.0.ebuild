# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Triple-DES EDE encryption/decryption"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="dev-perl/Crypt-DES"
BDEPEND="${RDEPEND}"
