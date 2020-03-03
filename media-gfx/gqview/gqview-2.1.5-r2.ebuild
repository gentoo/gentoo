# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools xdg-utils

DESCRIPTION="A GTK-based image browser"
HOMEPAGE="http://gqview.sourceforge.net/"
SRC_URI="mirror://sourceforge/gqview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4:2
	virtual/libintl"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-windows.patch
	"${FILESDIR}"/${P}-glibc.patch
	"${FILESDIR}"/${P}-gcc-10.patch
	"${FILESDIR}"/${P}-helpdir.patch
	"${FILESDIR}"/${P}-readmedir.patch
	"${FILESDIR}"/${P}-format-security.patch
)

src_prepare() {
	default

	sed -i \
		-e '/^Encoding/d' \
		-e '/^Icon/s/\.png//' \
		-e '/^Categories/s/Application;//' \
		gqview.desktop || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf --without-lcms
}

src_install() {
	default
	# bug #30111
	docompress -x /usr/share/doc/${PF}/README
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
