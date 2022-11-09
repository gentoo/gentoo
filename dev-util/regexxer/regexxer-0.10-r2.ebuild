# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2

DESCRIPTION="An interactive tool for performing search and replace operations"
HOMEPAGE="http://regexxer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-cpp/gtksourceviewmm:3.0"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-glib-2.32.patch
	"${FILESDIR}"/${P}-sandbox.patch
	"${FILESDIR}"/${P}-exception-prefdialog.patch
)

src_prepare() {
	default
	eautoreconf
}
