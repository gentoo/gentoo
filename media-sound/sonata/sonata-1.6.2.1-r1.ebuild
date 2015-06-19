# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sonata/sonata-1.6.2.1-r1.ebuild,v 1.4 2015/06/17 05:45:52 yngwin Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=true
inherit distutils-r1

DESCRIPTION="An elegant GTK+ music client for the Music Player Daemon (MPD)"
HOMEPAGE="http://www.nongnu.org/sonata/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
# now released at https://github.com/multani/sonata/releases

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="dbus lyrics taglib +trayicon"

RDEPEND=">=dev-python/pygtk-2.12
	|| ( x11-libs/gdk-pixbuf:2[jpeg] x11-libs/gtk+:2[jpeg] )
	>=dev-python/python-mpd-0.2.1
	dbus? ( dev-python/dbus-python )
	lyrics? ( dev-python/zsi )
	taglib? ( >=dev-python/tagpy-0.93 )
	trayicon? ( dev-python/egg-python )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="CHANGELOG README TODO TRANSLATORS"
PATCHES=( "${FILESDIR}"/${P}-mpd18-compat.patch )

src_install() {
	distutils-r1_src_install
	rm -rf "${D}"/usr/share/sonata
}
