# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Spell checking widget for GTK"
HOMEPAGE="http://gtkspell.sourceforge.net/"
# gtkspell doesn't use sourceforge mirroring system it seems.
SRC_URI="http://${PN}.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	x11-libs/gtk+:2
	>=app-text/enchant-1.1.6:0"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

src_prepare() {
	default

	# Fix intltoolize broken file, see upstream #577133
	sed -i -e "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" po/Makefile.in.in || die
}

src_configure() {
	econf --disable-gtk-doc
}

src_install() {
	default
	find "${ED}" -name '*.la' -type f -delete || die
}
