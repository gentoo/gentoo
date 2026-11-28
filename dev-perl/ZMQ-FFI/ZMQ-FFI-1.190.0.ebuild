# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GHENRY
DIST_VERSION=1.19
inherit perl-module

DESCRIPTION="Version agnostic Perl bindings for zeromq using ffi"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/Class-XSAccessor-1.180.0
	>=dev-perl/FFI-Platypus-0.860.0
	>=dev-perl/Import-Into-1.2.5
	>=dev-perl/Moo-1.4.5
	net-libs/zeromq
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/AnyEvent
		dev-perl/Sub-Override
		dev-perl/Sys-SigAction
	)
"
