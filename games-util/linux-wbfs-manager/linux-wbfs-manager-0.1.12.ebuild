# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="WBFS manager for Linux using GTK+"
HOMEPAGE="https://code.google.com/p/linux-wbfs-manager/"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/linux-wbfs-manager/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	gnome-base/libglade:2.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin wbfs_gtk
	einstalldocs

	make_desktop_entry wbfs_gtk "WBFS manager" applications-utilities
}
