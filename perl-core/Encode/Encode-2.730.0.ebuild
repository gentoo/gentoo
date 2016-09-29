# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DANKOGAI
MODULE_VERSION=2.73
inherit perl-module

DESCRIPTION="character encodings"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

SRC_TEST=do
PATCHES=( "${FILESDIR}"/gentoo_enc2xs.diff )
