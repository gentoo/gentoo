# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils virtualx

DESCRIPTION="GTK+ bindings for guile"
HOMEPAGE="https://www.gnu.org/software/guile-gtk/"
SRC_URI="mirror://gnu/guile-gtk/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-scheme/guile[deprecated(+)]
	x11-libs/gtk+:2
	gnome-base/libglade:2.0
	>=x11-libs/gtkglarea-1.90:2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0-g-object-ref.diff
	"${FILESDIR}"/${PV}-prll-install.patch
	"${FILESDIR}"/${PV}-brokentest.patch
)

src_prepare() {
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	autotools-utils_src_prepare
}

src_test() {
	cd "${BUILD_DIR}" || die
	Xemake check
}

src_install() {
	autotools-utils_src_install
	insinto /usr/share/doc/${PF}/
	doins -r examples
}
