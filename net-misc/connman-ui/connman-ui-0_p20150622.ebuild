# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools vcs-snapshot
COMMIT="fce0af94e121bde77c7fa2ebd6a319f0180c5516"

DESCRIPTION="A full-featured GTK based trayicon UI for ConnMan"
HOMEPAGE="https://github.com/tbursztyka/connman-ui"
SRC_URI="https://github.com/tbursztyka/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/gtk+:3
"
RDEPEND="${CDEPEND}
	net-misc/connman
"
DEPEND="${CDEPEND}
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}
