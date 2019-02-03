# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL="true"

inherit distutils-r1

DESCRIPTION="An elegant GTK+ music client for the Music Player Daemon (MPD)"
HOMEPAGE="http://www.nongnu.org/sonata/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
# now released at https://github.com/multani/sonata/releases

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus lyrics taglib"

RDEPEND="
	>=dev-python/pygtk-2.12:2
	x11-libs/gdk-pixbuf:2[jpeg]
	>=dev-python/python-mpd-0.2.1
	dbus? ( dev-python/dbus-python )
	lyrics? ( dev-python/zsi )
	taglib? ( >=dev-python/tagpy-0.93 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS="CHANGELOG README TODO TRANSLATORS"
PATCHES=( "${FILESDIR}"/${P}-mpd18-compat.patch )

src_install() {
	distutils-r1_src_install
	rm -rf "${D}"/usr/share/sonata
}
