# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="library implementing services that allow clients to discover and manipulate DLNA renderers"
HOMEPAGE="https://01.org/dleyna/"
SRC_URI="https://01.org/sites/default/files/downloads/dleyna/${P}.tar_2.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	>=dev-libs/glib-2.28:2
	>=media-libs/gupnp-dlna-0.9.4:2.0
	>=net-libs/dleyna-core-0.6.0
	>=net-libs/gssdp-1.2.0:0=
	>=net-libs/gupnp-1.2.0:0=
	>=net-libs/gupnp-av-0.11.5
	>=net-libs/libsoup-2.28.2:2.4
"
RDEPEND="${DEPEND}
	net-libs/dleyna-connector-dbus
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-gupnp-1.2.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
