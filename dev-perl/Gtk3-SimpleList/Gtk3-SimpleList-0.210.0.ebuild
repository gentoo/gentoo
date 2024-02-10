# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TVIGNAUD
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Simple interface to GTK+ 3's complex MVC list widget"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="amd64 ~arm64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Gtk3
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
