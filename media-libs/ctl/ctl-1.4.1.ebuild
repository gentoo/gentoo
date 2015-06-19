# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ctl/ctl-1.4.1.ebuild,v 1.15 2014/01/24 06:33:58 ssuominen Exp $

EAPI=5
inherit eutils libtool

DESCRIPTION="AMPAS' Color Transformation Language"
HOMEPAGE="http://sourceforge.net/projects/ampasctl"
SRC_URI="mirror://sourceforge/ampasctl/${P}.tar.gz"

LICENSE="AMPAS"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="static-libs"

RDEPEND="media-libs/ilmbase:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc4{3,7}.patch
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install
	dodoc AUTHORS ChangeLog NEWS README

	prune_libtool_files --all
}
