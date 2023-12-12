# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson

DESCRIPTION="A set of backgrounds packaged with the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-backgrounds"

LICENSE="CC-BY-SA-2.0 CC-BY-SA-3.0 CC-BY-2.0 CC-BY-4.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="gui-libs/gdk-pixbuf-loader-webp"
BDEPEND=">=sys-devel/gettext-0.19.8"
