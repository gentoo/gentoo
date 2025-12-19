# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LXDE Task manager"
HOMEPAGE="https://wiki.lxde.org/en/LXTask"
SRC_URI="https://downloads.sourceforge.net/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
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
