# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GAAS
MODULE_VERSION=2.53
inherit perl-module

DESCRIPTION="MD5 message digest algorithm"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/perl-Digest"
DEPEND="${RDEPEND}"

SRC_TEST=do
mydoc="rfc*.txt"
