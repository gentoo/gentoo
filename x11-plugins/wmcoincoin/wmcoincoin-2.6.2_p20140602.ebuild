# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcoincoin/wmcoincoin-2.6.2_p20140602.ebuild,v 1.4 2015/02/25 15:47:42 ago Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="a dockapp for browsing dacode news and board sites"
HOMEPAGE="http://hules.free.fr/wmcoincoin"
# Grab matching tag and Debian patches
SRC_URI="https://github.com/d-torrance/${PN}/archive/debian/${PV/_p/+}-1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls xinerama"

RDEPEND="x11-libs/gtk+:2
	media-libs/imlib2
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libX11
	x11-libs/libXft
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
	x11-libs/libXt
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	xinerama? ( x11-proto/xineramaproto )"

S=${WORKDIR}/${PN}-debian-${PV/_p/-}-1

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	EPATCH_SOURCE="${S}/debian/patches" EPATCH_SUFFIX=patch EPATCH_FORCE=yes epatch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable xinerama)
}
