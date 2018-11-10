# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=Digest
MODULE_AUTHOR=GAAS
MODULE_VERSION=1.17
inherit perl-module

DESCRIPTION="Modules that calculate message digests"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/perl-MIME-Base64"
DEPEND="${RDEPEND}"

SRC_TEST="do"
mydoc="rfc*.txt"
