# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#if LIVE
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"

inherit autotools git-r3
#endif

inherit eutils

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="https://bitbucket.org/mgorny/autoupnp/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND="net-libs/miniupnpc:0=
	libnotify? ( x11-libs/libtinynotify:0= )"
DEPEND="${RDEPEND}"

#if LIVE
KEYWORDS=
SRC_URI=

src_prepare() { eautoreconf; }
#endif

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
