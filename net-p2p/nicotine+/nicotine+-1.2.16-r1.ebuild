# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/nicotine+/nicotine+-1.2.16-r1.ebuild,v 1.1 2015/03/26 23:58:39 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="http://nicotine-plus.sourceforge.net"
SRC_URI="mirror://sourceforge/nicotine-plus/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	gnome-base/librsvg"

DEPEND="${RDEPEND}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e 's:\(Icon=\).*:\1nicotine-plus-32px:' \
		"${S}"/files/nicotine.desktop
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${D}"
	dosym nicotine.py /usr/bin/nicotine
}

pkg_postinst() {
	echo
	elog "You may want to install these packages to add additional features"
	elog "to Nicotine+:"
	elog
	elog "dev-python/geoip-python         Country lookup and flag display"
	elog "media-libs/mutagen              Media metadata extraction"
	elog "net-libs/miniupnpc              UPnP portmapping"
	echo
}
