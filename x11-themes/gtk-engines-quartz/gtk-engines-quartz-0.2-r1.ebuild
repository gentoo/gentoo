# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="gtk-quartz-engine-${PV}"

DESCRIPTION="OSX GTK+ Theme Engine"
HOMEPAGE="https://sourceforge.net/apps/trac/gtk-osx/wiki/GtkQuartzEngine"
SRC_URI="http://downloads.sourceforge.net/project/gtk-osx/GTK%20Quartz%20Engine/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-macos"

RDEPEND=">=x11-libs/gtk+-2.10:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
