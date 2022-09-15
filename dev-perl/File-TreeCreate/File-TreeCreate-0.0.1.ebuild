# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
inherit perl-module

DESCRIPTION="Recursively create a directory tree"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	virtual/perl-autodie
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Path
		virtual/perl-File-Spec
	)
"
