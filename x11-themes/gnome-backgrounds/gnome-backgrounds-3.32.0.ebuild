# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org meson

DESCRIPTION="A set of backgrounds packaged with the GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-backgrounds"

LICENSE="CC-BY-SA-2.0 CC-BY-SA-3.0 CC-BY-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc x86"
IUSE=""

RDEPEND="!<x11-themes/gnome-themes-standard-3.14"
DEPEND=">=sys-devel/gettext-0.19.8"
