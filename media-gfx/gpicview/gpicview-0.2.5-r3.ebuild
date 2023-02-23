# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="A Simple and Fast Image Viewer for X"
HOMEPAGE="http://lxde.sourceforge.net/gpicview"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

RDEPEND="media-libs/libjpeg-turbo
	x11-libs/gtk+:3[X]"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/Fix-displaying-images-with-GTK3.patch"
	"${FILESDIR}/${PN}-main_win_open-dummy-return.patch"
	"${FILESDIR}/${PN}-fix-animated-gifs.patch"
)

src_configure() {
	econf --enable-gtk3
}
