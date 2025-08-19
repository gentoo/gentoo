# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Simple GTK2 text editor"
HOMEPAGE="http://tarot.freeshell.org/leafpad/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs"

BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
DEPEND="
	virtual/libintl
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"

src_configure() {
    local myeconfargs=(
        --enable-chooser
        --enable-print
        $(use_enable emacs)
        econf ${myeconfargs[@]})
}
