# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-des-ede3/crypt-des-ede3-0.10.0-r1.ebuild,v 1.1 2014/08/22 14:47:41 axs Exp $

EAPI=5

MY_PN=Crypt-DES_EDE3
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
