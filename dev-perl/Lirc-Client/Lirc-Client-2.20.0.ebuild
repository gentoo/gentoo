# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MGRIMES
MODULE_VERSION=2.02
inherit perl-module

DESCRIPTION="A client library for the Linux Infrared Remote Control (LIRC)"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/File-Path-Expand
	>=dev-perl/Moo-1.0.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	virtual/perl-File-Spec
	virtual/perl-IO
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
