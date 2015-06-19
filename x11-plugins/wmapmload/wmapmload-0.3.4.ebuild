# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmapmload/wmapmload-0.3.4.ebuild,v 1.4 2014/08/10 20:04:08 slyfox Exp $

EAPI="3"

DESCRIPTION="dockapp that monitors your apm battery status"
SRC_URI="http://tnemeth.free.fr/projets/programmes/${P}.tar.gz"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
LICENSE="GPL-2"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_install () {
	emake DESTDIR="${D}" install || die "installation failed"
}
