# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fdo-mime gnome2-utils

DESCRIPTION="Baselayout for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
SRC_URI="https://dev.gentoo.org/~sera/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="!<dev-java/java-config-2.2"

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
