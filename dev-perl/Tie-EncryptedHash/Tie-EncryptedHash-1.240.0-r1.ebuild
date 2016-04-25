# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=VIPUL
MODULE_VERSION=1.24
inherit perl-module

DESCRIPTION="Hashes (and objects based on hashes) with encrypting fields"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Crypt-Blowfish
	dev-perl/Crypt-DES
	dev-perl/Crypt-CBC"
DEPEND="${RDEPEND}"

SRC_TEST=do
