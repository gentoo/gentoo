# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils git-r3

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="https://bitbucket.org/mgorny/autoupnp/"
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="libnotify"

RDEPEND="net-libs/miniupnpc:0=
	libnotify? ( x11-libs/libtinynotify:0= )"
DEPEND="${RDEPEND}"

src_prepare() {
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
	prune_libtool_files --all
}
