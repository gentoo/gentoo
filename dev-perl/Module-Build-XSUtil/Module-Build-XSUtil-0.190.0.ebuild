# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HIDEAKIO
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="A Module::Build class for building XS modules"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="examples"

RDEPEND="
	dev-perl/Devel-CheckCompiler
	virtual/perl-Devel-PPPort
	virtual/perl-Exporter
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-File-Path
	virtual/perl-XSLoader
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.500
	test? (
		dev-perl/Capture-Tiny
		dev-perl/Cwd-Guard
		>=dev-perl/File-Copy-Recursive-Reduced-0.2.0
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.980.0
	)

"

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x usr/share/doc/${PF}/eg/
		insinto usr/share/doc/${PF}
		doins -r eg
	fi
}
