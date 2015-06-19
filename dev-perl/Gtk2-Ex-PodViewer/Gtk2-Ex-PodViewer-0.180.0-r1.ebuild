# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gtk2-Ex-PodViewer/Gtk2-Ex-PodViewer-0.180.0-r1.ebuild,v 1.1 2014/08/25 02:10:08 axs Exp $

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
	dev-perl/gtk2-perl
	dev-perl/IO-stringy
	virtual/perl-Pod-Parser
	virtual/perl-Pod-Simple
	dev-perl/Gtk2-Ex-Simple-List
	dev-perl/Locale-gettext"
DEPEND="${RDEPEND}"
