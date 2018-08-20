# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EBHANSSEN
DIST_VERSION=v${PV}

inherit perl-module

DESCRIPTION="Trap exit codes, exceptions, output, etc"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Data-Dump
	virtual/perl-Exporter
	virtual/perl-File-Temp
	virtual/perl-IO
	virtual/perl-version
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.3
	test? (
		>=virtual/perl-Test-Simple-1.1.10
	)"
