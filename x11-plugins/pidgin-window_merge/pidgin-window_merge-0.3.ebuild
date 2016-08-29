# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="A Pidgin plugin that merges the Buddy List window with a conversation window"
HOMEPAGE="https://github.com/dm0-/window_merge"
SRC_URI="mirror://github/dm0-/${PN#pidgin-}/${P#pidgin-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/glib:2=
	net-im/pidgin:0=[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P#pidgin-}

pkg_postinst() {
	ewarn "This plugin and infopane plugin (purple-plugin_pack) activated"
	ewarn "at the same time cause a segfault in pidgin"
	ewarn "see https://github.com/dm0-/window_merge/issues/4"
}
