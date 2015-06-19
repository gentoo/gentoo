# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libXcm/libXcm-9999.ebuild,v 1.2 2014/08/25 09:25:29 xmw Exp $

EAPI=5

inherit autotools-multilib git-2

DESCRIPTION="reference implementation of the net-color spec"
HOMEPAGE="http://www.oyranos.org/libxcm/"
EGIT_REPO_URI="git://www.oyranos.org/git/xcolor"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="X static-libs"

RDEPEND="X? ( >=x11-libs/libXmu-1.1.1-r1[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		$(use_with X x11)
		$(use_enable static-libs static)
	)
	autotools-multilib_src_configure
}
