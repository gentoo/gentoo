# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GRANTM
DIST_VERSION=2.25
inherit perl-module

DESCRIPTION="An API for simple XML files"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	virtual/perl-Storable
	>=dev-perl/XML-NamespaceSupport-1.40.0
	>=dev-perl/XML-SAX-0.150.0
	dev-perl/XML-SAX-Expat
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"

PATCHES=("${FILESDIR}/${PN}-2.25-saxtests.patch")

PERL_RM_FILES=("t/author-pod-syntax.t")
