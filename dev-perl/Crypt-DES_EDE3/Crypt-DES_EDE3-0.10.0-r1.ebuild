# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BTROTT
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Triple-DES EDE encryption/decryption"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Crypt-DES"
DEPEND="${RDEPEND}"

SRC_TEST=do
