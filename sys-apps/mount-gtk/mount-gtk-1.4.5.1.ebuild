# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="GTK+ based UDisks2 frontend"
HOMEPAGE="http://mount-gtk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/glib-2.28
	sys-fs/udisks:2
	x11-libs/c++-gtk-utils:0
	x11-libs/libX11
	x11-libs/libnotify:=
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS BUGS ChangeLog )

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.2-c++11.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# acinclude.m4 is broken and environment flags override these:
	append-cxxflags -fexceptions -frtti -fsigned-char -fno-check-new -pthread
	econf
}
