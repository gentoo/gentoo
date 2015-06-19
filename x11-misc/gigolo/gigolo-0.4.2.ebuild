# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gigolo/gigolo-0.4.2.ebuild,v 1.3 2014/04/20 08:50:14 ago Exp $

EAPI=5
#EAUTORECONF=yes (Why was this in 0.4.1 w/o any calls to autotools.eclass again?
# some reference to intltoolize in ChangeLog but that's it?)
inherit xfconf

DESCRIPTION="a frontend to easily manage connections to remote filesystems using GIO/GVfs"
HOMEPAGE="http://www.uvena.de/gigolo/ http://goodies.xfce.org/projects/applications/gigolo"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/gtk+-2.12:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}

src_install() {
	xfconf_src_install
	rm -rf "${ED}"/usr/share/doc/${PN}
}
