# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="https://github.com/projg2/autoupnp/"
SRC_URI="
	https://github.com/projg2/autoupnp/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

DEPEND="
	<net-libs/miniupnpc-2.2.8:0=
	libnotify? ( x11-libs/libtinynotify:0= )
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	local emesonargs=(
		$(meson_feature libnotify)
	)
	meson_src_configure
}
