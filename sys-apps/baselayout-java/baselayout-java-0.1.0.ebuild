# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit gnome2-utils xdg-utils

DESCRIPTION="Baselayout for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
SRC_URI="https://dev.gentoo.org/~gyakovlev/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ppc ppc64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="!<dev-java/java-config-2.2"

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
