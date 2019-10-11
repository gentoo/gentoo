# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 systemd

DESCRIPTION="BitTorrent client with a client/server model"
HOMEPAGE="https://deluge-torrent.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.deluge-torrent.org/${PN}"
	SRC_URI=""
else
	SRC_URI="http://download.deluge-torrent.org/source/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="console geoip gtk libnotify sound webinterface"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	sound? ( gtk )
	libnotify? ( gtk )
"
PATCHES=(
	"${FILESDIR}/${PN}-1.3.5-disable_libtorrent_internal_copy.patch"
	"${FILESDIR}/${PN}-1.3.15-r1-fix-preferences-ui.patch"
)

DEPEND="<net-libs/libtorrent-rasterbar-1.2[python,${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-util/intltool
	acct-group/deluge
	acct-user/deluge"
RDEPEND="<net-libs/libtorrent-rasterbar-1.2[python,${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	|| ( >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
		(
		>=dev-python/twisted-core-13.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-web-13.0[${PYTHON_USEDEP}]
		)
	)
	geoip? ( dev-python/geoip-python[${PYTHON_USEDEP}] )
	gtk? (
		sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
		gnome-base/librsvg
		libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )
	)
	webinterface? ( dev-python/mako[${PYTHON_USEDEP}] )"

python_prepare_all() {
	local args=(
		-e "/Compiling po file/a \\\tuptoDate = False"
	)
	sed -i "${args[@]}" -- 'setup.py' || die
	args=(
		-e 's|"new_release_check": True|"new_release_check": False|'
		-e 's|"check_new_releases": True|"check_new_releases": False|'
		-e 's|"show_new_releases": True|"show_new_releases": False|'
	)
	sed -i "${args[@]}" -- 'deluge/core/preferencesmanager.py' || die

	distutils-r1_python_prepare_all
}

esetup.py() {
	# bug 531370: deluge has its own plugin system. No need to relocate its egg info files.
	# Override this call from the distutils-r1 eclass.
	# This does not respect the distutils-r1 API. DONOT copy this example.
	set -- "${PYTHON}" setup.py "$@"
	echo "$@"
	"$@" || die
}

python_install_all() {
	distutils-r1_python_install_all
	if ! use console ; then
		rm -rf "${D}/usr/$(get_libdir)/python2.7/site-packages/deluge/ui/console/" || die
		rm -f "${D}/usr/bin/deluge-console" || die
		rm -f "${D}/usr/share/man/man1/deluge-console.1" ||die
	fi
	if ! use gtk ; then
		rm -rf "${D}/usr/$(get_libdir)/python2.7/site-packages/deluge/ui/gtkui/" || die
		rm -rf "${D}/usr/share/icons/" || die
		rm -f "${D}/usr/bin/deluge-gtk" || die
		rm -f "${D}/usr/share/man/man1/deluge-gtk.1" || die
		rm -f "${D}/usr/share/applications/deluge.desktop" || die
	fi
	if use webinterface; then
		newinitd "${FILESDIR}/deluge-web.init" deluge-web
		newconfd "${FILESDIR}/deluge-web.conf" deluge-web
		systemd_newunit "${FILESDIR}/deluge-web.service-2" deluge-web.service
		systemd_install_serviced "${FILESDIR}/deluge-web.service.conf"
	else
		rm -rf "${D}/usr/$(get_libdir)/python2.7/site-packages/deluge/ui/web/" || die
		rm -f "${D}/usr/bin/deluge-web" || die
		rm -f "${D}/usr/share/man/man1/deluge-web.1" || die
	fi
	newinitd "${FILESDIR}"/deluged.init-2 deluged
	newconfd "${FILESDIR}"/deluged.conf-2 deluged
	systemd_newunit "${FILESDIR}"/deluged.service-2 deluged.service
	systemd_install_serviced "${FILESDIR}"/deluged.service.conf
}

pkg_postinst() {
	elog
	elog "If, after upgrading, deluge doesn't work, please remove the"
	elog "'~/.config/deluge' directory and try again, but make a backup"
	elog "first!"
	elog
	elog "To start the daemon either run 'deluged' as user"
	elog "or modify /etc/conf.d/deluged and run"
	elog "/etc/init.d/deluged start as root"
	elog "You can still use deluge the old way"
	elog
	elog "Systemd unit files for deluged and deluge-web no longer source"
	elog "/etc/conf.d/deluge* files. Environment variable customization now"
	elog "happens in /etc/systemd/system/deluged.service.d/00gentoo.conf"
	elog "and /etc/systemd/system/deluge-web.service.d/00gentoo.conf"
	elog
	elog "For more information look at https://dev.deluge-torrent.org/wiki/Faq"
	elog
}
