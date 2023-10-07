# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_EAUTORECONF="yes"
inherit gnome2

DESCRIPTION="Menu editor for Enlightenment DR16 written in GTK2"
HOMEPAGE="https://www.enlightenment.org https://sourceforge.net/projects/enlightenment/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=gnome-base/libglade-2.4
	x11-libs/gtk+:2
	x11-wm/e16
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-missing-include.patch
	"${FILESDIR}"/${PN}-autotools.patch
	"${FILESDIR}"/${PN}-no-common.patch
)
