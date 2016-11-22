# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="Help a new user get started in GNOME"
HOMEPAGE="https://help.gnome.org/"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="gnome-extra/gnome-user-docs"
DEPEND="
	app-text/yelp-tools
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"
