# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="LXDE keyboard and mouse configuration tool"
HOMEPAGE="https://lxde.org/"
SRC_URI="https://downloads.sourceforge.net/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

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
	# bug #944065
	append-flags -std=gnu17

	econf --enable-gtk3
}
