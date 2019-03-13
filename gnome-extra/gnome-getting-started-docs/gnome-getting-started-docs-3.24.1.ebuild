# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Help a new user get started in GNOME"
HOMEPAGE="https://help.gnome.org/"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="gnome-extra/gnome-user-docs"
DEPEND="app-text/yelp-tools"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"
