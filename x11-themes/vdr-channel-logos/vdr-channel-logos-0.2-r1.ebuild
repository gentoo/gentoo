# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/vdr-channel-logos/vdr-channel-logos-0.2-r1.ebuild,v 1.3 2014/09/25 21:58:59 hd_brummy Exp $

EAPI=5

inherit eutils

MY_P=${PN#vdr-channel-}-${PV}

DESCRIPTION="Logos for vdr-skin*"
HOMEPAGE="http://www.vdrskins.org/"
SRC_URI="http://www.vdrskins.org/vdrskins/albums/userpics/10138/${MY_P}.tar.gz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S=${WORKDIR}/logos

RDEPEND="app-text/convmv"

src_prepare() {

	convmv --notest --replace -f iso-8859-1 -t utf-8 -r "${S}"/
}

src_install() {
	insinto /usr/share/vdr/channel-logos
	find -maxdepth 1 -name "*.xpm" -print0|xargs -0 cp -a --target="${D}/usr/share/vdr/channel-logos/"
}
