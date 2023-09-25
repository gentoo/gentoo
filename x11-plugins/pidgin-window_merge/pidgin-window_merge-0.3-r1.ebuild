# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Pidgin plugin that merges the Buddy List window with a conversation window"
HOMEPAGE="https://github.com/dm0-/window_merge"
SRC_URI="mirror://gentoo/${P#pidgin-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE=""

RDEPEND="dev-libs/glib:2=
	net-im/pidgin:0=[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P#pidgin-}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	ewarn "This plugin and infopane plugin (purple-plugin_pack) activated"
	ewarn "at the same time cause a segfault in pidgin"
	ewarn "see https://github.com/dm0-/window_merge/issues/4"
}
