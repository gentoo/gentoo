# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openexr_ctl/openexr_ctl-1.0.1-r1.ebuild,v 1.12 2014/01/22 18:54:21 ssuominen Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="OpenEXR CTL libraries"
HOMEPAGE="http://sourceforge.net/projects/ampasctl"
SRC_URI="mirror://sourceforge/ampasctl/${P}.tar.gz"

LICENSE="AMPAS"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="static-libs"

RDEPEND="<media-libs/ilmbase-2.0.0:=
	<media-libs/openexr-2.0.0:=
	media-libs/ctl:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-{,configure_}gcc43.patch \
		"${FILESDIR}"/${P}-pkgconfig.patch \
		"${FILESDIR}"/${P}-gcc44.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
