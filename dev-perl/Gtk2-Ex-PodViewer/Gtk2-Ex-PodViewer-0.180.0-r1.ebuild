# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_AUTHOR=GBROWN
MODULE_VERSION=0.18
inherit perl-module

DESCRIPTION="a Gtk2 widget for displaying Plain old Documentation (POD)"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

#SRC_TEST="do"

RDEPEND="x11-libs/gtk+:2
	dev-perl/Gtk2
	dev-perl/IO-stringy
	virtual/perl-Pod-Parser
	virtual/perl-Pod-Simple
	dev-perl/Gtk2-Ex-Simple-List
	dev-perl/Locale-gettext"
DEPEND="${RDEPEND}"
