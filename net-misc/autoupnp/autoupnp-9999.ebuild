# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="https://github.com/mgorny/autoupnp/"
EGIT_REPO_URI="https://github.com/mgorny/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="libnotify"

RDEPEND="net-libs/miniupnpc:0=
	libnotify? ( x11-libs/libtinynotify:0= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_with libnotify)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
