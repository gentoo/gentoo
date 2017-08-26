# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="GTK update icon cache"
HOMEPAGE="https://www.gtk.org/ https://github.com/EvaSDK/gtk-update-icon-cache"
SRC_URI="https://dev.gentoo.org/~eva/distfiles/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
IUSE=""

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# man page was previously installed by gtk+:3 ebuild
RDEPEND="
	>=dev-libs/glib-2.49.4:2
	>=x11-libs/gdk-pixbuf-2.30:2
	!<x11-libs/gtk+-2.24.28-r1:2
	!<x11-libs/gtk+-3.22.2:3
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_configure() {
	# man pages are shipped in tarball
	gnome2_src_configure --disable-man
}

src_install() {
	gnome2_src_install
	doman docs/${PN}.1
}
