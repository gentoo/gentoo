# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org

DESCRIPTION="Help a new user get started in GNOME"
HOMEPAGE="https://help.gnome.org/"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

RDEPEND="gnome-extra/gnome-user-docs"
BDEPEND="dev-util/itstool"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"
