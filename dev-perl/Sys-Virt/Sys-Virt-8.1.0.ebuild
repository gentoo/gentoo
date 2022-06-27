# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DANBERR
DIST_VERSION=v${PV}
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="API for using the libvirt library from Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-emulation/libvirt-${PV}
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	dev-perl/Module-Build
	virtual/pkgconfig
	test? (
		virtual/perl-Test-Simple
		dev-perl/XML-XPath
		virtual/perl-Time-HiRes
	)"
DEPEND="
	>=app-emulation/libvirt-${PV}
"

src_compile() {
	MAKEOPTS+=" -j1" perl-module_src_compile
}
