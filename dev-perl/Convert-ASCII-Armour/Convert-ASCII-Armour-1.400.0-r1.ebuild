# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=VIPUL
MODULE_VERSION=1.4
inherit perl-module

DESCRIPTION="Convert binary octets into ASCII armoured messages"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="virtual/perl-IO-Compress
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64"
DEPEND="${RDEPEND}"

SRC_TEST=do
