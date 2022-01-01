# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BTROTT
DIST_VERSION=0.01
inherit perl-module

DESCRIPTION="Triple-DES EDE encryption/decryption"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="dev-perl/Crypt-DES"
BDEPEND="${RDEPEND}"
