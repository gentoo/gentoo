# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LXDE keyboard and mouse configuration tool"
HOMEPAGE="https://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86 ~x86-linux"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	econf \
		--enable-gtk3
}
