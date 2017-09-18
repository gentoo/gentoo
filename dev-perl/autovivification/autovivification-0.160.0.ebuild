# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_AUTHOR=VPIT
MODULE_VERSION=0.16
inherit perl-module

DESCRIPTION="Lexically disable autovivification"
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="virtual/perl-XSLoader"
DEPEND="${RDEPEND}
	virtual/perl-Exporter
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Test-Simple"

SRC_TEST="do"
