# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_NAME=gtk-quartz-engine-${PV}

DESCRIPTION="OSX GTK+ Theme Engine"
HOMEPAGE="https://sourceforge.net/apps/trac/gtk-osx/wiki/GtkQuartzEngine"
SRC_URI="http://downloads.sourceforge.net/project/gtk-osx/GTK%20Quartz%20Engine/${MY_NAME}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-macos"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_NAME}

src_prepare() {
	default
	eautoreconf
}
