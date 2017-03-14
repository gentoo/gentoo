# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ZEFRAM
MODULE_VERSION=0.009
inherit perl-module

DESCRIPTION="the Eksblowfish block cipher"

SLOT="0"
KEYWORDS="amd64"
IUSE=""
RDEPEND="
	>=dev-perl/Class-Mix-0.1.0
	>=virtual/perl-MIME-Base64-2.21
	virtual/perl-XSLoader
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	>=virtual/perl-ExtUtils-CBuilder-0.15
	virtual/perl-Test-Simple
"

SRC_TEST="do"
