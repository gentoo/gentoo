# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.009
inherit perl-module

DESCRIPTION="Eksblowfish block cipher"

SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-Mix-0.1.0
	virtual/perl-Exporter
	>=virtual/perl-MIME-Base64-2.210.0
	virtual/perl-XSLoader
	virtual/perl-parent
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	>=virtual/perl-ExtUtils-CBuilder-0.15
	test? (
		virtual/perl-Test-Simple
	)
"
