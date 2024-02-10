# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Pidgin's GLib Ncurses Toolkit"
HOMEPAGE="https://keep.imfreedom.org/libgnt/libgnt"
SRC_URI="mirror://sourceforge/pidgin/${P}.tar.xz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	!<net-im/pidgin-2.14.0
	dev-libs/glib:2
	dev-libs/libxml2
	sys-libs/ncurses:0=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.14.0-tinfo.patch"
)

src_configure() {
	local emesonargs=(
		-Dpython2=false
		$(meson_use doc)
	)
	meson_src_configure
}
