# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="C++ bindings for libgnomecanvas"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ppc64 sparc x86"
IUSE="doc"

RDEPEND="
	>=gnome-base/libgnomecanvas-2.6
	>=dev-cpp/gtkmm-2.4:2.4
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=( "${FILESDIR}"/${P}-disable-building-examples.patch )

src_compile() {
	gnome2_src_compile

	if use doc; then
		emake -C docs/reference all
		HTML_DOCS=( docs/reference/html/. )
	fi
}

src_install() {
	gnome2_src_install

	rm examples/Makefile* examples/*/Makefile* || die
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
