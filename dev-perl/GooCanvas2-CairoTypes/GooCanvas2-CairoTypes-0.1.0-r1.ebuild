# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ASOKOLOV
DIST_VERSION=0.001
inherit perl-module

DESCRIPTION="Bridge between GooCanvas2 and Cairo types"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Cairo
	dev-perl/glib-perl
	dev-perl/Gtk3
	x11-libs/cairo
	x11-libs/goocanvas:2.0[introspection]
"
BDEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
	)
"
