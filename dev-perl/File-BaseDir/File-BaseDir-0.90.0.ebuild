# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PLICEASE
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Use the Freedesktop.org base directory specification"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Spec
	dev-perl/IPC-System-Simple
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/File-Which
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=(
	t/04_pod_ok.t
	t/05_pod_cover.t
)
