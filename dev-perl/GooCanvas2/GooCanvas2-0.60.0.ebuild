# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PERLMAX
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl binding for GooCanvas2 widget using Glib::Object::Introspection"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	x11-libs/goocanvas:2.0
	dev-perl/Gtk3
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test
	)
"
