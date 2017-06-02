# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DANKOGAI
MODULE_VERSION=2.73
inherit perl-module

DESCRIPTION="character encodings"

SLOT="0"
KEYWORDS=""
IUSE=""

SRC_TEST=do
PATCHES=( "${FILESDIR}"/gentoo_enc2xs.diff )
