# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/autoupnp/autoupnp-0.4.6.ebuild,v 1.4 2014/07/06 13:20:48 mgorny Exp $

EAPI=4

inherit autotools-utils eutils

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="https://bitbucket.org/mgorny/autoupnp/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND="net-libs/miniupnpc
	libnotify? ( x11-libs/libtinynotify )"
DEPEND="${RDEPEND}"

src_configure() {
	myeconfargs=(
		$(use_with libnotify)
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	prune_libtool_files --all
}
