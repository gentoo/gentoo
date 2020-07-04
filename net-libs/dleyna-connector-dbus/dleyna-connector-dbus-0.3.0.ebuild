# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="utility library for higher level dLeyna libraries"
HOMEPAGE="https://01.org/dleyna/"
SRC_URI="https://01.org/sites/default/files/downloads/dleyna/${P}.tar_2.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/dleyna-core-0.2.1:1.0
	>=sys-apps/dbus-1
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
