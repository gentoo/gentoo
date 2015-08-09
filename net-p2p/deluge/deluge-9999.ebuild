# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 eutils systemd

DESCRIPTION="BitTorrent client with a client/server model"
HOMEPAGE="http://deluge-torrent.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://deluge-torrent.org/${PN}.git
		http://git.deluge-torrent.org/${PN}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://download.deluge-torrent.org/source/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="geoip gtk libnotify setproctitle sound webinterface"

DEPEND=">=net-libs/rb_libtorrent-0.14.9[python]
	dev-util/intltool"
RDEPEND=">=net-libs/rb_libtorrent-0.14.9[python]
	dev-python/chardet
	dev-python/pyopenssl
	dev-python/pyxdg
	>=dev-python/twisted-core-8.1
	>=dev-python/twisted-web-8.1
	geoip? ( dev-libs/geoip )
	gtk? (
		sound? ( dev-python/pygame )
		dev-python/pygobject:2
		>=dev-python/pygtk-2.12
		gnome-base/librsvg
		libnotify? ( dev-python/notify-python )
	)
	setproctitle? ( dev-python/setproctitle )
	webinterface? ( dev-python/mako )"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-1.3.5-disable_libtorrent_internal_copy.patch
	)

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	newinitd "${FILESDIR}"/deluged.init deluged
	newconfd "${FILESDIR}"/deluged.conf deluged
	systemd_dounit "${FILESDIR}"/deluged.service
	systemd_dounit "${FILESDIR}"/deluge-web.service
}

pkg_postinst() {
	elog
	elog "If after upgrading it doesn't work, please remove the"
	elog "'~/.config/deluge' directory and try again, but make a backup"
	elog "first!"
	elog
	elog "To start the daemon either run 'deluged' as user"
	elog "or modify /etc/conf.d/deluged and run"
	elog "/etc/init.d/deluged start as root"
	elog "You can still use deluge the old way"
	elog
	elog "For more information look at http://dev.deluge-torrent.org/wiki/Faq"
	elog
}
