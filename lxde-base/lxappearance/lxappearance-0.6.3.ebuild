# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="LXDE GTK+ theme switcher"
HOMEPAGE="https://wiki.lxde.org/en/LXAppearance"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~mips ppc x86 ~amd64-linux ~x86-linux"
IUSE="dbus"

RDEPEND="x11-libs/gtk+:2
	dbus? ( dev-libs/dbus-glib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_configure() {
	econf \
		$(use_enable dbus)
}
