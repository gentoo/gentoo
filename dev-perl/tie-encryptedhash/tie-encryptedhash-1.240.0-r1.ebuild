# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/tie-encryptedhash/tie-encryptedhash-1.240.0-r1.ebuild,v 1.1 2014/08/22 15:57:56 axs Exp $

EAPI=5

MY_PN=Tie-EncryptedHash
MODULE_AUTHOR=VIPUL
MODULE_VERSION=1.24
inherit perl-module

DESCRIPTION="Hashes (and objects based on hashes) with encrypting fields"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Crypt-Blowfish
	dev-perl/Crypt-DES
	dev-perl/crypt-cbc"
DEPEND="${RDEPEND}"

SRC_TEST=do
