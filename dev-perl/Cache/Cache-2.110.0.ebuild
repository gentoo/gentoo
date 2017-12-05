# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.11
inherit perl-module

DESCRIPTION="the Cache interface"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=virtual/perl-DB_File-1.720.0
	virtual/perl-Digest-SHA
	>=virtual/perl-File-Path-1.0.0
	>=virtual/perl-File-Spec-0.800.0
	>=virtual/perl-Storable-1.0.0
	>=dev-perl/Heap-0.10.0
	>=dev-perl/IO-String-1.20.0
	dev-perl/TimeDate
	>=dev-perl/File-NFSLock-1.200.0
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"
src_test() {
	perl_rm_files t/pod.t t/style-trailing-space.t
	perl-module_src_test
}
